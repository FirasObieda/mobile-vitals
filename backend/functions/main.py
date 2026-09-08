from typing import Optional
from io import BytesIO
import numpy as np
import pandas as pd
from joblib import load
from scipy.signal import find_peaks

import firebase_admin
from firebase_admin import firestore, storage
# Import 'Change' to correctly type the event
from firebase_functions.firestore_fn import Event, DocumentSnapshot, on_document_written, Change

# ------------------------
# Initialize Firebase (minimal at import)
# ------------------------
if not firebase_admin._apps:
    firebase_admin.initialize_app()

# ------------------------
# PPG FEATURE EXTRACTION
# ------------------------
def extract_ppg_features(ppg, fs=1000, prefix="ppg"):
    features = {}
    if len(ppg) == 0:
        keys = [
            "mean","std","min","max","range","skew","kurtosis",
            "hr_mean","hr_std","sdnn","rmssd",
            "sys_peak_mean","sys_peak_std",
            "dia_peak_mean","dia_peak_std",
            "pulse_amp_mean","pulse_amp_std",
            "ac_dc_ratio"
        ]
        for k in keys:
            features[f"{prefix}_{k}"] = 0
        return features

    features[f"{prefix}_mean"] = np.mean(ppg)
    features[f"{prefix}_std"] = np.std(ppg)
    features[f"{prefix}_min"] = np.min(ppg)
    features[f"{prefix}_max"] = np.max(ppg)
    features[f"{prefix}_range"] = features[f"{prefix}_max"] - features[f"{prefix}_min"]
    features[f"{prefix}_skew"] = pd.Series(ppg).skew()
    features[f"{prefix}_kurtosis"] = pd.Series(ppg).kurtosis()

    # Detect systolic and diastolic peaks
    min_prominence = max(0.2 * np.std(ppg), 0.01)
    sys_peaks, _ = find_peaks(ppg, distance=int(fs*0.6), prominence=min_prominence)
    dia_peaks, _ = find_peaks(-ppg, distance=int(fs*0.6), prominence=min_prominence)

    if len(sys_peaks) > 1:
        rr_intervals = np.diff(sys_peaks) / fs
        hr_series = 60 / rr_intervals
        features[f"{prefix}_hr_mean"] = np.mean(hr_series)
        features[f"{prefix}_hr_std"] = np.std(hr_series)
        features[f"{prefix}_sdnn"] = np.std(rr_intervals)
        features[f"{prefix}_rmssd"] = np.sqrt(np.mean(np.square(np.diff(rr_intervals))))
    else:
        features[f"{prefix}_hr_mean"] = 0
        features[f"{prefix}_hr_std"] = 0
        features[f"{prefix}_sdnn"] = 0
        features[f"{prefix}_rmssd"] = 0

    features[f"{prefix}_sys_peak_mean"] = np.mean(ppg[sys_peaks]) if len(sys_peaks) > 0 else 0
    features[f"{prefix}_sys_peak_std"] = np.std(ppg[sys_peaks]) if len(sys_peaks) > 0 else 0
    features[f"{prefix}_dia_peak_mean"] = np.mean(ppg[dia_peaks]) if len(dia_peaks) > 0 else 0
    features[f"{prefix}_dia_peak_std"] = np.std(ppg[dia_peaks]) if len(dia_peaks) > 0 else 0

    if len(sys_peaks) > 0 and len(dia_peaks) > 0:
        pulse_amps = []
        for s in sys_peaks:
            d_before = dia_peaks[dia_peaks < s]
            if len(d_before) > 0:
                pulse_amps.append(ppg[s] - ppg[d_before[-1]])
        features[f"{prefix}_pulse_amp_mean"] = np.mean(pulse_amps) if pulse_amps else 0
        features[f"{prefix}_pulse_amp_std"] = np.std(pulse_amps) if pulse_amps else 0
    else:
        features[f"{prefix}_pulse_amp_mean"] = 0
        features[f"{prefix}_pulse_amp_std"] = 0

    # AC/DC ratio
    dc = np.mean(ppg)
    ac = np.max(ppg) - np.min(ppg)
    features[f"{prefix}_ac_dc_ratio"] = ac / dc if dc != 0 else 0

    return features

# ------------------------
# FIRESTORE TRIGGER
# ------------------------
@on_document_written(document="/users/{userId}/ppg_sessions/{docId}",
                       memory=512)
def run_model_on_ppg(event: Event[Change[Optional[DocumentSnapshot]]]):
    
    if event.data.after is None:
        print("Document deleted. Skipping.")
        return

    # Initialize clients at runtime
    db = firestore.client()
    
    # --- THIS IS THE FIX ---
    # Use the correct bucket name you found in your test
    bucket = storage.bucket("sdp-08-health-tracking-app.firebasestorage.app")

    user_id = event.params["userId"]
    doc_id = event.params["docId"]

    session_data = event.data.after.to_dict()

    if session_data is None:
        print("Document data is empty. Skipping.")
        return

    red_ppg = np.array(session_data.get("red", []))
    ir_ppg = np.array(session_data.get("ir", []))
    green_ppg = np.array(session_data.get("green", []))

    # Extract features
    features = {}
    features.update(extract_ppg_features(red_ppg, prefix="red"))
    features.update(extract_ppg_features(ir_ppg, prefix="ir"))
    features.update(extract_ppg_features(green_ppg, prefix="green"))

    # User info (path fix)
    user_ref = db.document(f"users/{user_id}")
    user_data = user_ref.get().to_dict() or {}
    features["age"] = user_data.get("Age", 0)
    features["gender"] = 1 if str(user_data.get("Gender","")).lower() == "male" else 0
    features["height"] = user_data.get("Height", 0)
    features["weight"] = user_data.get("Weight", 0)
    features["bmi"] = features["weight"] / ((features["height"]/100)**2) if features["height"] else 0

    X = pd.DataFrame([features])

    # Load model
    try:
        blob = bucket.blob("rf_dataset1.pkl")
        model_bytes = blob.download_as_bytes()
        model = load(BytesIO(model_bytes))
    except Exception as e:
        print(f"❌ Could not load model: {e}")
        return

    # Align features
    try:
        X = X[model.feature_names_in_]
    except AttributeError:
        print("⚠️ model.feature_names_in_ not found; skipping alignment")
    except KeyError as e:
        print(f"⚠️ Missing feature: {e}")
        # return  # Consider returning if a key feature is missing

    # Predict
    try:
        y_pred = model.predict(X)
        print("✅ Prediction:", y_pred[0])
    except Exception as e:
        print(f"❌ Prediction failed: {e}")
        return

    # Write to Firestore (path fix)
    health_ref = db.document(f"users/{user_id}/HealthVitals/{doc_id}")
    health_ref.set({
        "SBP": float(y_pred[0][0]),
        "DBP": float(y_pred[0][1]),
        "BPM": float(y_pred[0][2]),  # HR
        "SpO2": float(y_pred[0][3])
    }, merge=True)

    print(f"✅ Predictions written for user {user_id}, session {doc_id}")


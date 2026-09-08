from typing import Any, Optional
from io import BytesIO
import json

import numpy as np
import pandas as pd
from joblib import load
from scipy.signal import find_peaks

import firebase_admin
from firebase_admin import firestore, storage
from cloudevents.http import CloudEvent
import functions_framework

if not firebase_admin._apps:
    # Rely on the default credentials and project metadata that Cloud Functions
    # inject at runtime (FIREBASE_CONFIG, GCLOUD_PROJECT, etc.).
    firebase_admin.initialize_app()

_MODEL_CACHE: Optional[object] = None
_MODEL_FEATURE_ORDER: Optional[list[str]] = None


def extract_ppg_features(ppg: np.ndarray, fs: int = 500, prefix: str = "ppg") -> dict:
    features: dict[str, float] = {}
    if len(ppg) == 0:
        keys = [
            "mean",
            "std",
            "min",
            "max",
            "range",
            "skew",
            "kurtosis",
            "hr_mean",
            "hr_std",
            "sdnn",
            "rmssd",
            "sys_peak_mean",
            "sys_peak_std",
            "dia_peak_mean",
            "dia_peak_std",
            "pulse_amp_mean",
            "pulse_amp_std",
            "ac_dc_ratio",
        ]
        for name in keys:
            features[f"{prefix}_{name}"] = 0.0
        return features

    features[f"{prefix}_mean"] = float(np.mean(ppg))
    features[f"{prefix}_std"] = float(np.std(ppg))
    features[f"{prefix}_min"] = float(np.min(ppg))
    features[f"{prefix}_max"] = float(np.max(ppg))
    features[f"{prefix}_range"] = features[f"{prefix}_max"] - features[f"{prefix}_min"]
    features[f"{prefix}_skew"] = float(pd.Series(ppg).skew())
    features[f"{prefix}_kurtosis"] = float(pd.Series(ppg).kurtosis())

    min_prominence = max(0.2 * np.std(ppg), 0.01)
    sys_peaks, _ = find_peaks(ppg, distance=int(fs * 0.6), prominence=min_prominence)
    dia_peaks, _ = find_peaks(-ppg, distance=int(fs * 0.6), prominence=min_prominence)

    if len(sys_peaks) > 1:
        rr_intervals = np.diff(sys_peaks) / fs
        hr_series = 60 / rr_intervals
        features[f"{prefix}_hr_mean"] = float(np.mean(hr_series))
        features[f"{prefix}_hr_std"] = float(np.std(hr_series))
        features[f"{prefix}_sdnn"] = float(np.std(rr_intervals))
        features[f"{prefix}_rmssd"] = float(np.sqrt(np.mean(np.square(np.diff(rr_intervals)))))
    else:
        features[f"{prefix}_hr_mean"] = 0.0
        features[f"{prefix}_hr_std"] = 0.0
        features[f"{prefix}_sdnn"] = 0.0
        features[f"{prefix}_rmssd"] = 0.0

    features[f"{prefix}_sys_peak_mean"] = (
        float(np.mean(ppg[sys_peaks])) if len(sys_peaks) > 0 else 0.0
    )
    features[f"{prefix}_sys_peak_std"] = (
        float(np.std(ppg[sys_peaks])) if len(sys_peaks) > 0 else 0.0
    )
    features[f"{prefix}_dia_peak_mean"] = (
        float(np.mean(ppg[dia_peaks])) if len(dia_peaks) > 0 else 0.0
    )
    features[f"{prefix}_dia_peak_std"] = (
        float(np.std(ppg[dia_peaks])) if len(dia_peaks) > 0 else 0.0
    )

    if len(sys_peaks) > 0 and len(dia_peaks) > 0:
        pulse_amps: list[float] = []
        for s_peak in sys_peaks:
            d_before = dia_peaks[dia_peaks < s_peak]
            if len(d_before) > 0:
                pulse_amps.append(float(ppg[s_peak] - ppg[d_before[-1]]))
        if pulse_amps:
            features[f"{prefix}_pulse_amp_mean"] = float(np.mean(pulse_amps))
            features[f"{prefix}_pulse_amp_std"] = float(np.std(pulse_amps))
        else:
            features[f"{prefix}_pulse_amp_mean"] = 0.0
            features[f"{prefix}_pulse_amp_std"] = 0.0
    else:
        features[f"{prefix}_pulse_amp_mean"] = 0.0
        features[f"{prefix}_pulse_amp_std"] = 0.0

    dc = float(np.mean(ppg))
    ac = float(np.max(ppg) - np.min(ppg))
    features[f"{prefix}_ac_dc_ratio"] = ac / dc if dc != 0.0 else 0.0

    return features


def _load_model(bucket: Any) -> Optional[object]:
    """Load and cache the model artifact to avoid repeated downloads."""
    global _MODEL_CACHE, _MODEL_FEATURE_ORDER
    if _MODEL_CACHE is not None:
        return _MODEL_CACHE

    try:
        blob = bucket.blob("rf_dataset1.pkl")
        model_bytes = blob.download_as_bytes()
        loaded_model = load(BytesIO(model_bytes))
        _MODEL_CACHE = loaded_model
        if hasattr(loaded_model, "feature_names_in_"):
            _MODEL_FEATURE_ORDER = list(loaded_model.feature_names_in_)
        return loaded_model
    except Exception as exc:
        print(f"Failed to load model: {exc}")
        return None


@functions_framework.cloud_event
def run_model_on_ppg(event: CloudEvent) -> None:
    payload = event.data
    print(f"Received event data type: {type(payload).__name__}")
    if isinstance(payload, bytes):
        try:
            payload = json.loads(payload.decode("utf-8"))
        except Exception as exc:
            print(f"Failed to decode bytes payload: {exc}")
            payload = {}
    elif isinstance(payload, str):
        try:
            payload = json.loads(payload)
        except Exception as exc:
            print(f"Failed to decode string payload: {exc}")
            payload = {}
    elif payload is None:
        payload = {}
    elif not isinstance(payload, dict):
        print(f"Unexpected payload type: {type(payload)}")
        payload = {}

    subject = ""
    if hasattr(event, "get"):
        try:
            subject = event.get("subject", "")  # type: ignore[call-arg]
        except TypeError:
            subject = ""

    if not subject:
        value = payload.get("value") if isinstance(payload, dict) else None
        if isinstance(value, dict):
            subject = value.get("name", "")

    if not subject:
        print("Event subject missing; unable to resolve document path.")
        return

    print(f"Resolved subject: {subject}")
    segments = subject.split("/")
    try:
        user_index = segments.index("users") + 1
        session_index = segments.index("ppg_sessions") + 1
        user_id = segments[user_index]
        doc_id = segments[session_index]
    except (ValueError, IndexError):
        print(f"Unexpected document path in subject: {subject}")
        return

    print(f"Resolved user_id={user_id}, doc_id={doc_id}")
    db = firestore.client()
    bucket = storage.bucket()

    session_ref = db.document(f"users/{user_id}/ppg_sessions/{doc_id}")
    snapshot = session_ref.get()
    if not snapshot.exists:
        print(f"Session doc missing for users/{user_id}/ppg_sessions/{doc_id}")
        return

    session_data = snapshot.to_dict() or {}
    if not session_data:
        print("Document data is empty. Skipping.")
        return

    if session_data.get("source") == "init":
        print(
            f"Session {doc_id} for user {user_id} marked as init; skipping prediction."
        )
        return

    red_raw = session_data.get("red", [])
    ir_raw = session_data.get("ir", [])
    green_raw = session_data.get("green", [])

    red_ppg = np.array(red_raw if isinstance(red_raw, list) else [], dtype=float)
    ir_ppg = np.array(ir_raw if isinstance(ir_raw, list) else [], dtype=float)
    green_ppg = np.array(green_raw if isinstance(green_raw, list) else [], dtype=float)

    if min(len(red_ppg), len(ir_ppg), len(green_ppg)) == 0:
        print(
            f"PPG session {doc_id} for user {user_id} has insufficient samples; skipping."
        )
        return

    print(
        "PPG sample sizes",
        {
            "red": len(red_ppg),
            "ir": len(ir_ppg),
            "green": len(green_ppg),
        },
    )

    features: dict[str, float] = {}
    features.update(extract_ppg_features(red_ppg, prefix="red"))
    features.update(extract_ppg_features(ir_ppg, prefix="ir"))
    features.update(extract_ppg_features(green_ppg, prefix="green"))

    user_ref = db.document(f"users/{user_id}")
    user_data = user_ref.get().to_dict() or {}
    features["age"] = float(user_data.get("Age", 0) or 0)
    gender_raw = str(user_data.get("Gender", "")).lower()
    features["gender"] = 1.0 if gender_raw == "male" else 0.0
    features["height"] = float(user_data.get("Height", 0) or 0)
    features["weight"] = float(user_data.get("Weight", 0) or 0)
    height_cm = features["height"]
    features["bmi"] = (
        features["weight"] / ((height_cm / 100.0) ** 2) if height_cm else 0.0
    )

    X = pd.DataFrame([features])

    model = _load_model(bucket)
    if model is None:
        return

    try:
        feature_order = _MODEL_FEATURE_ORDER or model.feature_names_in_  # type: ignore[attr-defined]
        X = X[feature_order]
    except AttributeError:
        print("Model is missing feature_names_in_. Skipping alignment.")
    except KeyError as exc:
        print(f"Data frame is missing required feature: {exc}")

    try:
        y_pred = model.predict(X)
        prediction = y_pred[0]
        sbp, dbp, hr, spo2 = [float(value) for value in prediction]
        print(f"Prediction generated for user {user_id}, session {doc_id}: {prediction}")
    except Exception as exc:
        print(f"Prediction failed: {exc}")
        return

    health_ref = db.document(f"users/{user_id}/HealthVitals/{doc_id}")
    health_ref.set(
        {
            "SBP": round(sbp, 3),
            "DBP": round(dbp, 3),
            "BPM": round(hr, 3),
            "SpO2": round(spo2, 3),
            "userRef": user_ref,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        },
        merge=True,
    )

    print(f"Predictions written to users/{user_id}/HealthVitals/{doc_id}")

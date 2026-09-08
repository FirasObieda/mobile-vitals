import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.signal import butter, filtfilt, savgol_filter, find_peaks
import random

# ------------------------
# PARAMETERS
# ------------------------
Fs = 1000             # Sampling frequency (Hz)
cutoff = 15           # Low-pass filter cutoff (Hz)
order = 8             # Order of low-pass filter
target_length = 2100  # All signals will have this length

# Paths
base_path = r"C:\Users\user\Desktop\Senior 2 Work\Prediction Model"
meta_file = os.path.join(base_path, "PPG-BP dataset.xlsx")
signals_path = os.path.join(base_path, "signals")

output_csv = os.path.join(base_path, "ppg_bp_features_extended.csv")
output_npy = os.path.join(base_path, "ppg_bp_signals_features.npy")

# ------------------------
# HELPER FUNCTIONS
# ------------------------
def butter_lowpass(cutoff, fs, order=8):
    nyq = 0.5 * fs
    normal_cutoff = cutoff / nyq
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    return b, a

def apply_lowpass(ppg, cutoff=15.0, fs=1000, order=8):
    b, a = butter_lowpass(cutoff, fs, order=order)
    return filtfilt(b, a, ppg)

def savgol_smooth(ppg, window=21, polyorder=3):
    return savgol_filter(ppg, window_length=window, polyorder=polyorder)

def normalize_ppg(ppg):
    return (ppg - np.min(ppg)) / (np.max(ppg) - np.min(ppg))

def pad_or_truncate(ppg, target_len=2100):
    if len(ppg) > target_len:
        return ppg[:target_len]
    elif len(ppg) < target_len:
        return np.pad(ppg, (0, target_len - len(ppg)), 'constant')
    return ppg

def load_ppg(file_path):
    try:
        ppg = pd.read_csv(file_path, header=None, sep=r"\s+").values.flatten()
        return ppg
    except Exception as e:
        print(f"⚠️ Could not load {file_path}: {e}")
        return None

# ------------------------
# STEP 1 — LOAD METADATA
# ------------------------
df_meta = pd.read_excel(meta_file)

required_columns = [
    "subject_ID", 
    "Sex(M/F)", 
    "Age(year)", 
    "BMI(kg/m^2)", 
    "Systolic Blood Pressure(mmHg)", 
    "Diastolic Blood Pressure(mmHg)", 
    "Heart Rate(b/m)"
]
df_meta = df_meta[required_columns]
df_meta.columns = ["subject_ID", "Gender", "Age", "BMI", "SBP", "DBP", "HR"]

# ------------------------
# STEP 2 — LOAD SIGNALS & EXTRACT FEATURES
# ------------------------
all_features = []
all_signals_features = []

for _, row in df_meta.iterrows():
    subject_id = row["subject_ID"]
    gender, age, bmi = row["Gender"], row["Age"], row["BMI"]
    sbp, dbp, hr_meta = row["SBP"], row["DBP"], row["HR"]

    for seg in range(1, 4):
        file_name = f"{subject_id}_{seg}.txt"
        file_path = os.path.join(signals_path, file_name)

        if not os.path.exists(file_path):
            continue

        ppg = load_ppg(file_path)
        if ppg is None:
            continue

        # Preprocess
        ppg = apply_lowpass(ppg, cutoff, Fs, order)
        ppg = savgol_smooth(ppg)
        ppg = normalize_ppg(ppg)

        # -------------------- PEAK DETECTION --------------------
        sys_peaks, _ = find_peaks(ppg, distance=int(Fs*0.6), prominence=0.2*np.std(ppg))
        valleys, _ = find_peaks(-ppg, distance=int(Fs*0.6))

        # Diastolic peaks
        dia_peaks = []
        for sp in sys_peaks:
            next_valleys = valleys[valleys > sp]
            if len(next_valleys) == 0:
                continue
            nv = next_valleys[0]
            segment = ppg[sp:nv]
            local_max, _ = find_peaks(segment, prominence=0.05*np.std(ppg))
            if len(local_max) > 0:
                dp = sp + local_max[0]
                dia_peaks.append(dp)

        # Ensure at least one diastolic peak
        if len(dia_peaks) == 0 and len(sys_peaks) > 0:
            dia_peaks.append(np.argmin(ppg[sys_peaks[0]:]) + sys_peaks[0])

        # -------------------- BASIC FEATURES --------------------
        pulse_amplitudes = []
        ibi = np.diff(sys_peaks) / Fs if len(sys_peaks) > 1 else []
        for sp in sys_peaks:
            prev_valleys = valleys[valleys < sp]
            if len(prev_valleys) > 0:
                amp = ppg[sp] - ppg[prev_valleys[-1]]
                pulse_amplitudes.append(amp)

        avg_pulse_amp = np.mean(pulse_amplitudes) if pulse_amplitudes else 0
        mean_sys_peak = np.mean(ppg[sys_peaks]) if len(sys_peaks) > 0 else 0
        mean_dia_peak = np.mean(ppg[dia_peaks]) if len(dia_peaks) > 0 else 0

        # HRV metrics with validity flags
        if len(ibi) > 1:
            sdnn = np.std(ibi)
            sdnn_valid = True
        else:
            sdnn = 0
            sdnn_valid = False

        if len(ibi) > 2:
            rmssd = np.sqrt(np.mean(np.square(np.diff(ibi))))
            rmssd_valid = True
        else:
            rmssd = 0
            rmssd_valid = False

        # Pulse widths
        pw50 = pw75 = 0
        if len(sys_peaks) > 0:
            half_level = (np.max(ppg) - np.min(ppg)) * 0.5 + np.min(ppg)
            three_q_level = (np.max(ppg) - np.min(ppg)) * 0.75 + np.min(ppg)
            above_half = np.where(ppg >= half_level)[0]
            above_three_q = np.where(ppg >= three_q_level)[0]
            if len(above_half) > 1:
                pw50 = (above_half[-1] - above_half[0]) / Fs
            if len(above_three_q) > 1:
                pw75 = (above_three_q[-1] - above_three_q[0]) / Fs

        # Augmentation Index & Reflection Index (fallbacks)
        augmentation_index = (mean_dia_peak / mean_sys_peak) if mean_sys_peak else 0
        reflection_index = (avg_pulse_amp / mean_sys_peak) if mean_sys_peak else 0

        # APG features
        apg = np.gradient(np.gradient(ppg))
        a_wave = np.max(apg) if len(apg) > 0 else 0
        b_wave = np.min(apg) if len(apg) > 0 else 0
        b_over_a = b_wave / a_wave if a_wave else 0

        # -------------------- HR MISMATCH --------------------
        detected_hr = 60 / np.mean(ibi) if len(ibi) > 0 else hr_meta
        hr_mismatch_flag = abs(detected_hr - hr_meta) > 10  # flag if mismatch > 10 BPM

        # -------------------- COMPILE FEATURES --------------------
        features = {
            "Subject": subject_id,
            "Segment": seg,
            "SBP": sbp,
            "DBP": dbp,
            "HR": hr_meta,
            "Detected_HR": detected_hr,
            "HR_mismatch_flag": hr_mismatch_flag,
            "BMI": bmi,
            "Age": age,
            "Gender": gender,
            "Mean_Systolic_Peak": mean_sys_peak,
            "Mean_Diastolic_Peak": mean_dia_peak,
            "Average_Pulse_Amplitude": avg_pulse_amp,
            "Num_Systolic_Peaks": len(sys_peaks),
            "Num_Diastolic_Peaks": len(dia_peaks),
            "PW50": pw50,
            "PW75": pw75,
            "SDNN": sdnn,
            "SDNN_valid": sdnn_valid,
            "RMSSD": rmssd,
            "RMSSD_valid": rmssd_valid,
            "Augmentation_Index": augmentation_index,
            "Reflection_Index": reflection_index,
            "a_wave": a_wave,
            "b_wave": b_wave,
            "b_over_a_ratio": b_over_a
        }

        all_features.append(features)
        all_signals_features.append(pad_or_truncate(ppg, target_length))

        print(f"✅ Processed {file_name} (S:{len(sys_peaks)}, D:{len(dia_peaks)}, HR mismatch: {hr_mismatch_flag})")

# ------------------------
# STEP 3 — SAVE RESULTS
# ------------------------
df_features = pd.DataFrame(all_features)
df_features.to_csv(output_csv, index=False)
np.save(output_npy, np.vstack(all_signals_features))

print(f"🎯 Features saved to CSV: {output_csv}")
print(f"🎯 Padded signals saved to: {output_npy}")

# ------------------------
# STEP 4 — VISUALIZATION
# ------------------------
if len(all_features) > 0:
    # Pick a random sample
    idx = random.randint(0, len(all_features)-1)
    feats = all_features[idx]
    sig = all_signals_features[idx]

    # Re-detect peaks for plotting
    sys_peaks, _ = find_peaks(sig, distance=int(Fs*0.6), prominence=0.2*np.std(sig))
    valleys, _ = find_peaks(-sig, distance=int(Fs*0.6))

    dia_peaks = []
    for sp in sys_peaks:
        next_valleys = valleys[valleys > sp]
        if len(next_valleys) == 0:
            continue
        nv = next_valleys[0]
        segment = sig[sp:nv]
        local_max, _ = find_peaks(segment, prominence=0.05*np.std(sig))
        if len(local_max) > 0:
            dp = sp + local_max[0]
            dia_peaks.append(dp)

    # Plot signal
    plt.figure(figsize=(12, 6))
    plt.plot(sig, label="PPG Signal", color="blue")
    plt.scatter(sys_peaks, sig[sys_peaks], color="red", marker="o", label="Systolic Peaks")
    if len(dia_peaks) > 0:
        plt.scatter(dia_peaks, sig[dia_peaks], color="green", marker="x", label="Diastolic Peaks")

    plt.title(f"Subject {feats['Subject']} Segment {feats['Segment']} - PPG with Features")
    plt.xlabel("Samples")
    plt.ylabel("Normalized Amplitude")
    plt.legend()

    # Add extracted features as text box (skip Subject/Segment for clarity)
    feature_text = "\n".join([
        f"{k}: {v:.2f}" if isinstance(v, (int, float, np.floating)) else f"{k}: {v}"
        for k, v in feats.items() if k not in ["Subject", "Segment"]
    ])
    plt.gcf().text(0.75, 0.3, feature_text, fontsize=9,
                   bbox=dict(facecolor="white", alpha=0.7))

    plt.tight_layout()
    plt.show()
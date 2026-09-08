import os
import pandas as pd
import numpy as np
from scipy.signal import butter, filtfilt
from scipy.signal import savgol_filter

# ------------------------
# PATHS
# ------------------------
dataset_path = r"C:\Users\user\Desktop\Senior 2 Work\Prediction Model"
signals_path = os.path.join(dataset_path, "signals")
metadata_path = os.path.join(dataset_path, "PPG-BP dataset.xlsx")

# Updated output filenames with "_LPF"
output_csv = os.path.join(dataset_path, "ppg_bp_training_ready_wide_filtered_LPF.csv")
output_npy = os.path.join(dataset_path, "ppg_bp_signals_LPF.npy")

# ------------------------
# PARAMETERS
# ------------------------
Fs = 1000          # Sampling frequency (Hz)
cutoff = 15     # Low-pass filter cutoff (Hz)
order = 8         # Order of the low-pass filter
target_length = 2100  # all signals will have this length

# ------------------------
# HELPER FUNCTIONS
# ------------------------
def butter_lowpass(cutoff, fs, order=8):
    """Create a low-pass Butterworth filter."""
    nyq = 0.5 * fs
    normal_cutoff = cutoff / nyq
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    return b, a

def apply_lowpass(ppg, cutoff=15.0, fs=1000, order=8):
    """Apply a low-pass filter to the PPG signal."""
    b, a = butter_lowpass(cutoff, fs, order=order)
    return filtfilt(b, a, ppg)

def savgol_smooth(ppg, window=21, polyorder=3):
    return savgol_filter(ppg, window_length=window, polyorder=polyorder)


def normalize_ppg(ppg):
    """Normalize PPG values between 0 and 1."""
    return (ppg - np.min(ppg)) / (np.max(ppg) - np.min(ppg))

def load_ppg(file_path):
    """Load a PPG txt file, apply low-pass filtering, normalize, and pad/truncate."""
    try:
        df = pd.read_csv(file_path, header=None, delim_whitespace=True)
        ppg = df.values.flatten()

        # Apply filters
        ppg = apply_lowpass(ppg, cutoff, Fs, order)
        ppg = savgol_smooth(ppg, window=21, polyorder=3)
        ppg = normalize_ppg(ppg)

        # Ensure fixed length
        if len(ppg) < target_length:
            ppg = np.pad(ppg, (0, target_length - len(ppg)), 'constant')
        else:
            ppg = ppg[:target_length]

        return ppg
    except Exception as e:
        print(f"❌ Failed to load {file_path}: {e}")
        return None

# ------------------------
# STEP 1 — READ METADATA
# ------------------------
df_meta = pd.read_excel(metadata_path)
required_columns = ["subject_ID", "Sex(M/F)", "Age(year)", "BMI(kg/m^2)",
                    "Systolic Blood Pressure(mmHg)", "Diastolic Blood Pressure(mmHg)", "Heart Rate(b/m)"]

missing_cols = [c for c in required_columns if c not in df_meta.columns]
if missing_cols:
    raise ValueError(f"Metadata missing columns: {missing_cols}")

df_meta = df_meta[required_columns]
df_meta.columns = ["subject_ID", "Gender", "Age", "BMI", "SBP", "DBP", "HR"]
df_meta["subject_ID"] = df_meta["subject_ID"].astype(str)

# ------------------------
# STEP 2 — LOAD SIGNALS & FLATTEN INTO COLUMNS
# ------------------------
all_data = []
all_signals = []

for _, row in df_meta.iterrows():
    subject_id = row["subject_ID"]
    gender = row["Gender"]
    age = row["Age"]
    bmi = row["BMI"]
    sbp, dbp, hr = row["SBP"], row["DBP"], row["HR"]

    for seg in range(1, 4):
        file_name = f"{subject_id}_{seg}.txt"
        file_path = os.path.join(signals_path, file_name)

        if not os.path.exists(file_path):
            print(f"⚠️ Missing file: {file_name}")
            continue

        ppg = load_ppg(file_path)
        if ppg is None:
            continue

        # Store wide row for CSV
        segment_data = {
            "Subject": subject_id,
            "Segment": seg,
            "SBP": sbp,
            "DBP": dbp,
            "HR": hr,
            "BMI": bmi,
            "Age": age,
            "Gender": gender
        }
        for i, value in enumerate(ppg):
            segment_data[f"PPG_{i+1}"] = value
        all_data.append(segment_data)

        # Store just the signal for NPY
        all_signals.append(ppg)
        print(f"✅ Processed {file_name} ({len(ppg)} samples)")

# ------------------------
# STEP 3 — SAVE CSV
# ------------------------
if all_data:
    df_final = pd.DataFrame(all_data)
    try:
        df_final.to_csv(output_csv, index=False)
        print(f"\n🎯 Final WIDE CSV dataset with LPF ready! Saved to: {output_csv}")
    except PermissionError:
        print(f"❌ Permission denied: Close any program using {output_csv} and try again.")
else:
    print("❌ No data processed for CSV.")

# ------------------------
# STEP 4 — SAVE NPY
# ------------------------
if all_signals:
    np.save(output_npy, np.array(all_signals))
    print(f"🎯 NPY signals saved with LPF! Shape: {np.array(all_signals).shape}, Path: {output_npy}")
else:
    print("❌ No signals saved for NPY.")

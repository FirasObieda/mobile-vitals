import os
import glob
import numpy as np
import pandas as pd
from scipy.signal import butter, filtfilt, savgol_filter, find_peaks
from tqdm import tqdm

# ------------------------
# PARAMETERS
# ------------------------
Fs = 1000             # Sampling frequency (Hz)
cutoff = 15          # Low-pass cutoff (Hz)
order = 8            # Filter order
window_duration = 10 # seconds (default)
metadata_columns = ["source_file", "activity", "time", "gender", "height", "weight", "age", "bmi"]

# Updated folder path
data_folder = r"C:\Users\user\Desktop\Senior 2 Work\new dataset\Physionet Dataset Organized"
output_csv = r"C:\Users\user\Desktop\Senior 2 Work\new dataset\ppg_features_all_subjects.csv"

# ------------------------
# FILTERING FUNCTIONS
# ------------------------
def butter_lowpass(cutoff, fs, order=8):
    nyq = 0.5 * fs
    normal_cutoff = cutoff / nyq
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    return b, a

def apply_lowpass(ppg, cutoff=15.0, fs=500, order=8):
    b, a = butter_lowpass(cutoff, fs, order=order)
    return filtfilt(b, a, ppg)

def savgol_smooth(ppg, window=21, polyorder=3):
    return savgol_filter(ppg, window_length=window, polyorder=polyorder)

def normalize_ppg(ppg):
    if np.max(ppg) - np.min(ppg) == 0:
        return ppg
    return (ppg - np.min(ppg)) / (np.max(ppg) - np.min(ppg))

# ------------------------
# FEATURE EXTRACTION FUNCTION
# ------------------------
def extract_ppg_features(ppg, fs=500, prefix="ppg"):
    features = {}
    features[f"{prefix}_mean"] = np.mean(ppg)
    features[f"{prefix}_std"] = np.std(ppg)
    features[f"{prefix}_min"] = np.min(ppg)
    features[f"{prefix}_max"] = np.max(ppg)
    features[f"{prefix}_range"] = features[f"{prefix}_max"] - features[f"{prefix}_min"]
    features[f"{prefix}_skew"] = pd.Series(ppg).skew()
    features[f"{prefix}_kurtosis"] = pd.Series(ppg).kurtosis()

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

    if len(sys_peaks) > 0:
        features[f"{prefix}_sys_peak_mean"] = np.mean(ppg[sys_peaks])
        features[f"{prefix}_sys_peak_std"] = np.std(ppg[sys_peaks])
    else:
        features[f"{prefix}_sys_peak_mean"] = 0
        features[f"{prefix}_sys_peak_std"] = 0

    if len(dia_peaks) > 0:
        features[f"{prefix}_dia_peak_mean"] = np.mean(ppg[dia_peaks])
        features[f"{prefix}_dia_peak_std"] = np.std(ppg[dia_peaks])
    else:
        features[f"{prefix}_dia_peak_mean"] = 0
        features[f"{prefix}_dia_peak_std"] = 0

    if len(sys_peaks) > 0 and len(dia_peaks) > 0:
        pulse_amps = []
        for s in sys_peaks:
            d_before = dia_peaks[dia_peaks < s]
            if len(d_before) > 0:
                d = d_before[-1]
                pulse_amps.append(ppg[s] - ppg[d])
        if pulse_amps:
            features[f"{prefix}_pulse_amp_mean"] = np.mean(pulse_amps)
            features[f"{prefix}_pulse_amp_std"] = np.std(pulse_amps)
        else:
            features[f"{prefix}_pulse_amp_mean"] = 0
            features[f"{prefix}_pulse_amp_std"] = 0
    else:
        features[f"{prefix}_pulse_amp_mean"] = 0
        features[f"{prefix}_pulse_amp_std"] = 0

    return features

# ------------------------
# DATASET PROCESSING FUNCTION
# ------------------------
def process_dataset(file_path, fs=Fs, window_duration=window_duration, metadata_cols=None):
    df = pd.read_csv(file_path)

    # Interpolate NaNs
    df[["pleth_1", "pleth_2", "pleth_3"]] = df[["pleth_1", "pleth_2", "pleth_3"]].interpolate().fillna(method="bfill").fillna(method="ffill")

    # Labels
    df["bp_sys"] = df["bp_sys_end"]
    df["bp_dia"] = df["bp_dia_end"]
    df["hr"] = df["hr_2_end"]
    df["spo2"] = df["spo2_end"]

    wavelength_map = {"pleth_1": "red", "pleth_2": "ir", "pleth_3": "green"}

    # Adjust window size automatically if file is shorter
    max_window_size = fs * window_duration
    if len(df) < max_window_size:
        window_size = len(df)  # Use full file length
    else:
        window_size = max_window_size
    num_windows = max((len(df) - window_size) // window_size + 1, 1)

    features_list = []
    for w in range(num_windows):
        start_idx = w * window_size
        end_idx = start_idx + window_size
        if end_idx > len(df):
            end_idx = len(df)
            start_idx = end_idx - window_size
            if start_idx < 0:
                continue  # skip if file too short

        segment_data = {}
        for pleth in wavelength_map.keys():
            segment_data[pleth] = df[pleth].iloc[start_idx:end_idx].values
            segment_data[pleth] = normalize_ppg(
                savgol_smooth(
                    apply_lowpass(segment_data[pleth], cutoff=cutoff, fs=fs, order=order),
                    window=21, polyorder=3
                )
            )

        feats = {}
        for pleth, prefix in wavelength_map.items():
            feats.update(extract_ppg_features(segment_data[pleth], fs=fs, prefix=prefix))

        # AC/DC ratio
        for pleth, prefix in wavelength_map.items():
            dc = np.mean(segment_data[pleth])
            ac = np.std(segment_data[pleth])
            feats[f"{prefix}_ac_dc_ratio"] = ac / dc if dc != 0 else 0

        # Metadata first
        if metadata_cols is not None:
            metadata = df.iloc[end_idx - 1][metadata_cols]
            feats = {**metadata.to_dict(), **feats}

        # Labels last
        labels = df.iloc[end_idx - 1][["bp_sys", "bp_dia", "hr", "spo2"]]
        feats.update(labels.to_dict())

        features_list.append(feats)

    return pd.DataFrame(features_list)

# ------------------------
# PROCESS ALL SUBJECTS
# ------------------------
file_list = sorted(glob.glob(os.path.join(data_folder, "[Ss]*.csv")))
all_features = []

for fpath in tqdm(file_list, desc="Processing subjects"):
    df_features = process_dataset(fpath, fs=Fs, window_duration=window_duration, metadata_cols=metadata_columns)
    print(f"{os.path.basename(fpath)} -> {len(df_features)} windows extracted")
    if len(df_features) > 0:
        all_features.append(df_features)

if all_features:
    features_df_all = pd.concat(all_features, ignore_index=True)
    features_df_all.fillna(0, inplace=True)
    features_df_all.to_csv(output_csv, index=False)
    print(f"✅ All subjects processed and saved to {output_csv}")
else:
    print("⚠️ No windows were extracted from any file. Check file names, columns, or window size.")

# Mobile Vitals: AI-Powered Health Tracker with ML Predictions & Alerts

Senior Design Project — Department of Computer Engineering, University of Sharjah
(Fall 2025–2026)

**Team:** Majid M. Almheiri · Firas Obieda Abu-Bader · Abdullah Kaddoura
**Supervisor:** Dr. Bassel Soudan

## Overview

Chronic conditions like hypertension, hypoxemia, and heart-rate irregularities are
hard to catch early because the standard measurement tools (cuffs, pulse oximeters)
are manual, invasive, and non-continuous. **Mobile Vitals** is a wearable device that
continuously and non-invasively estimates **heart rate (HR), blood pressure (BP), and
blood oxygen saturation (SpO₂)** from a PPG (photoplethysmography) signal, streams
the data to the cloud, runs it through a trained ML model, and alerts the user through
a companion mobile app when a reading falls outside a normal range.

## How it works

1. A compact ESP32-based wearable captures PPG, skin temperature, and motion data.
2. Readings are sent over **Bluetooth** to the mobile app (Wi-Fi on the wearable
   proved unreliable in practice, so the design was changed to Bluetooth
   wearable↔phone, Wi-Fi phone↔cloud).
3. The app double-buffers readings and uploads them to **Firebase Firestore** every
   ~10 seconds.
4. A Firebase Cloud Function preprocesses the signal and runs it through a trained
   **Random Forest** model (selected after comparing Random Forest, XGBoost, and
   LightGBM) to predict HR, systolic/diastolic BP, and SpO₂.
5. Predictions are written back to Firestore and shown live in the app; abnormal
   readings trigger a two-tier (yellow/red) alert.

![Assembled wearable device](assets/images/highlevelview.png)

## Repository structure

```
firmware/     ESP32 (Arduino) firmware — sensor capture & Bluetooth transmission
backend/      Firebase Cloud Function (Python) that runs the ML inference model
mobile-app/   Flutter/FlutterFlow app — pairing, live vitals, history, alerts
ml/ppg-bp/    ML pipeline trained on the PPG-BP dataset (superseded, kept for reference)
ml/ptt-ppg/   ML pipeline trained on the PTT-PPG dataset — the one used in the final model
hardware/     KiCad PCB design files for the wearable
```

## Hardware

| Component | Model | Purpose |
|---|---|---|
| Microcontroller | Seeed Studio XIAO ESP32-C3 | Main processing unit |
| PPG sensor | MAX30105 | Captures the PPG waveform used for inference |
| Temperature sensor | MLX90614 | Contactless skin temperature (IR) |
| IMU | LSM6DS3 | Motion/orientation, for motion-artifact handling |
| Display | Waveshare 1.69" LCD | Shows HR, SpO₂, temperature, BP |
| Power | 3.7V 800mAh Li-Po + TP4056 charger | Portable power + USB charging |
| Enclosure | Custom 3D-printed casing (Onshape) | Protection & wearability |

![Assembled wearable device](assets/images/schematic.png)

Communication between sensors uses I²C/SPI on the wearable; wearable↔phone is
Bluetooth; phone↔cloud is Wi-Fi.

## Machine learning

Two datasets were evaluated:

- **PPG-BP** (Figshare, 657 segments / 219 subjects) — initial results were weak
  (best overall MAE ≈ 7.1, from XGBoost) and the dataset was judged not reliable
  enough.
- **PTT PPG** (PhysioNet, 22 subjects, 3,233 records across sit/run/walk) — much
  stronger results. **Random Forest** gave the best overall performance: SBP R² ≈
  0.955, DBP R² ≈ 0.921, HR R² ≈ 0.827, SpO₂ R² ≈ 0.845, overall MAE ≈ 1.31.

Preprocessing pipeline: linear interpolation for gaps → Butterworth low-pass filter
(15 Hz, 8th order) → Savitzky–Golay smoothing → normalization to [0,1] →
segmentation into 10-second windows.

## Software specifications

| Tool / Library | Version | Purpose |
|---|---|---|
| Arduino IDE | 2.3.2 | Firmware upload for the XIAO ESP32-C3 |
| Pandas | 2.2.3 | Data cleaning/manipulation |
| NumPy | 1.26.4 | Numerical computation |
| SciPy | 1.13.1 | Filtering & feature extraction |
| scikit-learn | 1.4.2 | Model training/evaluation |
| Joblib | 1.4.2 | Model persistence |
| firebase-admin (Python) | 6.4.0 | Cloud Function ↔ Firebase access |
| functions-framework | 3.6.0 | Serves the Python Cloud Function |
| cloudevents | 1.11.0 | Event handling for Cloud Functions |

## Setup

Each subfolder has more detail — start here:

- **Firmware:** open `firmware/ESP32_SOURCE_CODE.ino` in the Arduino IDE with the
  ESP32 board package installed.
- **Backend:** see the Backend section below and `backend/functions/requirements.txt`.
  Requires your own Firebase service account key (not included — see Configuration note).
- **Mobile app:** see `mobile-app/README.md`.
- **ML pipelines:** open the notebooks under `ml/ppg-bp/` or `ml/ptt-ppg/` in Jupyter.
- **Hardware:** open `hardware/wearable_device_sdp.kicad_pro` in KiCad.

### Backend (`backend/`)
```bash
cd backend/functions
python -m venv venv
source venv/bin/activate   # venv\Scripts\activate on Windows
pip install -r requirements.txt
```
This uses the Firebase Admin SDK, which needs a service account key that is **not
included** in this repo:
1. Firebase console → Project Settings → Service Accounts → Generate new private key.
2. Save it locally and point `GOOGLE_APPLICATION_CREDENTIALS` at it.
3. Never commit this file (it's covered by `.gitignore`).

Deploy: `firebase deploy --only functions` from `backend/`.

## Configuration note

This repo doesn't include environment-specific credentials (Firebase service
account key, API keys) — that's standard practice for any public repo. See the
Backend and `mobile-app/README.md` sections for how to supply your own.

## Project report

The full SDP2 report (architecture rationale, literature review, testing, and
results in detail) is available separately and covers material summarized above,
including the design evolution from the SDP1 proposal (dual PPG sensors → single
MAX30105; BME280 → MLX90614; Wi-Fi → Bluetooth for the wearable link; breadboard →
custom PCB).


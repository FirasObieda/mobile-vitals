# Mobile Vitals — Mobile App

Flutter/FlutterFlow companion app for the Mobile Vitals wearable. Connects to the
wearable device over Bluetooth, buffers and uploads PPG readings to Firebase, and
displays live health vitals (HR, blood pressure, SpO₂) with a two-tier (yellow/red)
alert system.

## Stack
- **Flutter** (built with FlutterFlow)
- **Firebase**: Auth, Firestore, Cloud Functions, Storage
- Bluetooth communication with the ESP32-based wearable (see `../firmware`)

## Structure
- `lib/` — app source (screens, auth, Bluetooth pairing, device pages, alerts, history, settings, etc.)
- `firebase/` — Firestore rules, indexes, storage rules, and the project's Cloud Functions (JS + Python)
- `android/`, `ios/`, `web/` — platform targets

## Setup
1. Install [Flutter](https://docs.flutter.dev/get-started/install) (stable channel).
2. `flutter pub get`
3. Add your own Firebase client config (not included in this repo):
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

   Download these from your Firebase project's console (Project Settings → Your apps).
4. This app calls the Gemini API. Provide your own key at build/run time rather than
   hardcoding it:
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your_key_here
   ```
5. Run: `flutter run`

## Firebase backend
See `firebase/functions/` for the Node.js Cloud Functions and
`firebase/cloud_functions_python/` for the Python function that runs the trained
ML model against incoming PPG data. Deploy with the Firebase CLI from `firebase/`:
```bash
firebase deploy --only functions,firestore:rules,storage
```

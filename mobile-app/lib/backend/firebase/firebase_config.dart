import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDfA24C8cL9yE3D-fOaWGmcOF2jLyaffuY",
            authDomain: "sdp-08-health-tracking-app.firebaseapp.com",
            projectId: "sdp-08-health-tracking-app",
            storageBucket: "sdp-08-health-tracking-app.firebasestorage.app",
            messagingSenderId: "680028527961",
            appId: "1:680028527961:web:2570c55c81ff9b3fb4c048"));
  } else {
    await Firebase.initializeApp();
  }
}

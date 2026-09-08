// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

Future<void> createLatestDoc() async {
  final userRef = currentUserReference;
  if (userRef == null) {
    return;
  }

  final docRef = userRef.collection('ppg_live').doc('latest');

  final existing = await docRef.get();
  if (existing.exists) {
    return;
  }

  // Generate 50 dummy samples for each color channel
  final List<int> dummyGreen = List<int>.filled(50, 0);
  final List<int> dummyRed = List<int>.filled(50, 0);
  final List<int> dummyIr = List<int>.filled(50, 0);

  // Create the document
  await docRef.set({
    'seq': 0,
    't0': DateTime.now().toIso8601String(),
    'dt_ms': 2, // 2 ms = 500 Hz
    'ppgGreen': dummyGreen,
    'ppgRed': dummyRed,
    'ppgIr': dummyIr,
    'deviceId': 'ESP32-C3',
    'updatedAt': FieldValue.serverTimestamp(),
  });

  print('✅ ppg_live/latest document created successfully!');
}

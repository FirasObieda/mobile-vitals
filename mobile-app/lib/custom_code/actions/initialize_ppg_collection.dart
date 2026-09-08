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

Future<void> initializePpgCollection() async {
  final userRef = currentUserReference;
  if (userRef == null) {
    return;
  }

  final sessionDoc = userRef.collection('ppg_sessions').doc('live');
  final snapshot = await sessionDoc.get();

  if (snapshot.exists) {
    return;
  }

  await sessionDoc.set({
    'created_at': FieldValue.serverTimestamp(),
    'source': 'init',
    'ir': <int>[],
    'red': <int>[],
    'green': <int>[],
    'current_hr': 0,
    'len_ir': 0,
    'len_red': 0,
    'len_green': 0,
  });
}

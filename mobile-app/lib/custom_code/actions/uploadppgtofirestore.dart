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
import '/auth/firebase_auth/auth_util.dart'; // <- gives currentUserReference, currentUserUid

Future<void> uploadppgtofirestore() async {
  // must be logged in
  final userRef = currentUserReference;
  if (userRef == null) return;

  final sessionRef = userRef.collection('ppg_sessions').doc();

  const currentHr = 0.0;

  await sessionRef.set({
    'created_at': FieldValue.serverTimestamp(),
    'source': 'synthetic',
    'ir': FFAppState().ppgIRL1,
    'red': FFAppState().ppgRedL1,
    'green': FFAppState().ppgGreenL1,
    'current_hr': currentHr,
    'len_ir': FFAppState().ppgIRL1.length,
    'len_red': FFAppState().ppgRedL1.length,
    'len_green': FFAppState().ppgGreenL1.length,
  });

  // clear L1 so next L2→L1 swap can proceed
  FFAppState().update(() {
    FFAppState().ppgIRL1 = <int>[];
    FFAppState().ppgRedL1 = <int>[];
    FFAppState().ppgGreenL1 = <int>[];
  });
}

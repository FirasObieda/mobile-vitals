// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// lib/custom_code/actions/uploadppgtofirestorelive.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

Future<void> uploadppgtofirestorelive() async {
  final uid = currentUserUid;
  if (uid.isEmpty) return;

  // Helpers
  List<int> firstN(List<int> src, int n) =>
      (src.length <= n) ? List<int>.from(src) : src.sublist(0, n);

  // If L1 has fewer than 50, just keep it capped and exit (nothing to upload yet)
  if (FFAppState().ppgIRL1.length < 50 ||
      FFAppState().ppgRedL1.length < 50 ||
      FFAppState().ppgGreenL1.length < 50) {
    // Defensive cap to avoid accidental growth
    FFAppState().update(() {
      FFAppState().ppgIRL1 = firstN(FFAppState().ppgIRL1, 50);
      FFAppState().ppgRedL1 = firstN(FFAppState().ppgRedL1, 50);
      FFAppState().ppgGreenL1 = firstN(FFAppState().ppgGreenL1, 50);
    });
    return;
  }

  // Take exactly the first 50 from L1 (FIFO window)
  final ir50 = firstN(FFAppState().ppgIRL1, 50);
  final red50 = firstN(FFAppState().ppgRedL1, 50);
  final green50 = firstN(FFAppState().ppgGreenL1, 50);
  const currentHr = 0.0;

  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('ppg_sessions')
      .doc('live'); // always overwrite this doc

  await docRef.set({
    'updated_at': FieldValue.serverTimestamp(),
    'source': 'live',
    'ir': ir50,
    'red': red50,
    'green': green50,
    'current_hr': currentHr,
    'len_ir': ir50.length,
    'len_red': red50.length,
    'len_green': green50.length,
  }, SetOptions(merge: false)); // hard overwrite: no appending

  // Clear L1 and immediately pull next 50 from L2 if available
  FFAppState().update(() {
    // Clear L1
    FFAppState().ppgIRL1.clear();
    FFAppState().ppgRedL1.clear();
    FFAppState().ppgGreenL1.clear();

    // If L2 has 50+ waiting, move the next 50 into L1
    const take = 50;
    if (FFAppState().ppgIRL2.length >= take &&
        FFAppState().ppgRedL2.length >= take &&
        FFAppState().ppgGreenL2.length >= take) {
      FFAppState().ppgIRL1 =
          List<int>.from(FFAppState().ppgIRL2.sublist(0, take));
      FFAppState().ppgRedL1 =
          List<int>.from(FFAppState().ppgRedL2.sublist(0, take));
      FFAppState().ppgGreenL1 =
          List<int>.from(FFAppState().ppgGreenL2.sublist(0, take));

      FFAppState().ppgIRL2.removeRange(0, take);
      FFAppState().ppgRedL2.removeRange(0, take);
      FFAppState().ppgGreenL2.removeRange(0, take);
    }
  });
}

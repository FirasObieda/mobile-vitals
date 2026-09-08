// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Additional imports (keep inside the "Action Code" box in FlutterFlow)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Purpose: cap L1 arrays to last 50 and overwrite one Firestore doc each time.
Future<void> uploadOverwrite50() async {
  // --- Helpers ---
  List<int> _toIntList(List<dynamic>? src) {
    if (src == null) return <int>[];
    // Convert any num/double to int safely
    return src.map((e) => (e as num).toInt()).toList();
  }

  List<int> _lastN(List<int> list, int n) {
    if (list.length <= n) return List<int>.from(list);
    return list.sublist(list.length - n);
  }

  // --- 1) Read from AppState and cap to 50 ---
  final irL1 = _toIntList(FFAppState().ppgIRL1);
  final redL1 = _toIntList(FFAppState().ppgRedL1);
  final greenL1 = _toIntList(FFAppState().ppgGreenL1);

  final ir50 = _lastN(irL1, 50);
  final red50 = _lastN(redL1, 50);
  final green50 = _lastN(greenL1, 50);

  // Also write capped arrays back to AppState so they never grow beyond 50
  FFAppState().ppgIRL1 = ir50;
  FFAppState().ppgRedL1 = red50;
  FFAppState().ppgGreenL1 = green50;

  // --- 2) Overwrite Firestore doc ---
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  // Adjust this path if your schema differs
  final ref = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('ppg_live')
      .doc('live'); // fixed doc id → always overwritten

  await ref.set({
    'ppgIR': ir50,
    'ppgRed': red50,
    'ppgGreen': green50,
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: false)); // force complete overwrite
}

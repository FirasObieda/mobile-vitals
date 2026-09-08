// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// lib/custom_code/actions/ppgenqueuefromstring.dart

// (Keep the auto header/imports FlutterFlow puts above; do NOT add new imports.)

// File-level memory for de-dup (top-level vars are OK in FlutterFlow actions)
int? _lastIR;
int? _lastRed;
int? _lastGreen;
// Heart-rate data is no longer provided by the BLE payload, so we only keep
// track of IR/Red/Green channels.

Future<void> ppgenqueuefromstring(String line) async {
  final raw = line.trim().replaceAll('\r', '');
  if (raw.isEmpty) return;

  final parts = raw.split(',');
  if (parts.length < 3) return; // expect IR,RED,GREEN tuple

  final ir = int.tryParse(parts[0].trim());
  final red = int.tryParse(parts[1].trim());
  final green = int.tryParse(parts[2].trim());
  if (ir == null || red == null || green == null) return;

  // De-dup: skip if identical to last ingested sample
  if (_lastIR == ir && _lastRed == red && _lastGreen == green) return;
  _lastIR = ir;
  _lastRed = red;
  _lastGreen = green;

  // Append to L2
  FFAppState().update(() {
    FFAppState().ppgIRL2.add(ir);
    FFAppState().ppgRedL2.add(red);
    FFAppState().ppgGreenL2.add(green);
  });

  // If L1 is empty and L2 has ≥ 50, move exactly first 50 (FIFO) L2 → L1
  const take = 50;
    final l1Empty = FFAppState().ppgIRL1.isEmpty &&
      FFAppState().ppgRedL1.isEmpty &&
      FFAppState().ppgGreenL1.isEmpty;

  if (l1Empty &&
      FFAppState().ppgIRL2.length >= take &&
      FFAppState().ppgRedL2.length >= take &&
      FFAppState().ppgGreenL2.length >= take) {
    FFAppState().update(() {
      FFAppState().ppgIRL1 =
          List<int>.from(FFAppState().ppgIRL2.sublist(0, take));
      FFAppState().ppgRedL1 =
          List<int>.from(FFAppState().ppgRedL2.sublist(0, take));
      FFAppState().ppgGreenL1 =
          List<int>.from(FFAppState().ppgGreenL2.sublist(0, take));
      FFAppState().ppgIRL2.removeRange(0, take);
      FFAppState().ppgRedL2.removeRange(0, take);
      FFAppState().ppgGreenL2.removeRange(0, take);
    });
  }
}

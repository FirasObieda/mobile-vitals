// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';
import 'dart:async';

// File: lib/custom_code/actions/init_ppg_buffers.dart

Future<void> initppgbuffers() async {
  FFAppState().update(() {
    // Clear all L1 & L2 lists
    FFAppState().ppgIRL1 = <int>[];
    FFAppState().ppgRedL1 = <int>[];
    FFAppState().ppgGreenL1 = <int>[];
    FFAppState().ppgIRL2 = <int>[];
    FFAppState().ppgRedL2 = <int>[];
    FFAppState().ppgGreenL2 = <int>[];

    // Reset indexes and counts
    FFAppState().ppgIRL2Index = 0;
    FFAppState().ppgRedL2Index = 0;
    FFAppState().ppgGreenL2Index = 0;

    FFAppState().ppgIRL1Count = 0;
    FFAppState().ppgRedL1Count = 0;
    FFAppState().ppgGreenL1Count = 0;

    // Stop synthetic stream if it’s running
    FFAppState().syntheticRunning = false;
  });
}

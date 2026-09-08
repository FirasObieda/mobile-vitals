// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// lib/custom_code/actions/start_synthetic_ppg.dart
import 'dart:math';
import 'dart:async';

Future<void> startsyntheticppg() async {
  if (FFAppState().syntheticRunning == true) return;
  FFAppState().syntheticRunning = true;

  double t = 0.0;
  const int hz = 500; // fixed defaults to avoid FF parameter parsing
  const int batchSize = 10; // fixed defaults
  final dt = 1.0 / hz;
  final rnd = Random();

  void writeToL2AndSwapIfNeeded(
      {required String channel, required int sample}) {
    if (channel == 'IR') {
      if (FFAppState().ppgIRL2.length < 50) {
        FFAppState().ppgIRL2.add(sample);
        FFAppState().ppgIRL2Index = FFAppState().ppgIRL2.length;
      }
      if (FFAppState().ppgIRL2.length >= 50) {
        if (FFAppState().ppgIRL1Count == 0) {
          FFAppState().ppgIRL1 = List<int>.from(FFAppState().ppgIRL2);
          FFAppState().ppgIRL1Count = 50;
          FFAppState().ppgIRL2 = <int>[];
          FFAppState().ppgIRL2Index = 0;
        }
      }
    } else if (channel == 'RED') {
      if (FFAppState().ppgRedL2.length < 50) {
        FFAppState().ppgRedL2.add(sample);
        FFAppState().ppgRedL2Index = FFAppState().ppgRedL2.length;
      }
      if (FFAppState().ppgRedL2.length >= 50) {
        if (FFAppState().ppgRedL1Count == 0) {
          FFAppState().ppgRedL1 = List<int>.from(FFAppState().ppgRedL2);
          FFAppState().ppgRedL1Count = 50;
          FFAppState().ppgRedL2 = <int>[];
          FFAppState().ppgRedL2Index = 0;
        }
      }
    } else if (channel == 'GREEN') {
      if (FFAppState().ppgGreenL2.length < 50) {
        FFAppState().ppgGreenL2.add(sample);
        FFAppState().ppgGreenL2Index = FFAppState().ppgGreenL2.length;
      }
      if (FFAppState().ppgGreenL2.length >= 50) {
        if (FFAppState().ppgGreenL1Count == 0) {
          FFAppState().ppgGreenL1 = List<int>.from(FFAppState().ppgGreenL2);
          FFAppState().ppgGreenL1Count = 50;
          FFAppState().ppgGreenL2 = <int>[];
          FFAppState().ppgGreenL2Index = 0;
        }
      }
    }
  }

  while (FFAppState().syntheticRunning) {
    FFAppState().update(() {
      for (int i = 0; i < batchSize; i++) {
        t += dt;
        final base = (sin(2 * pi * 1.2 * t) * 500 + 1500).round();
        final ir = base + (rnd.nextDouble() * 30 - 15).round();
        final red = base + (rnd.nextDouble() * 40 - 20).round() + 50;
        final grn = base + (rnd.nextDouble() * 40 - 20).round() - 50;

        writeToL2AndSwapIfNeeded(channel: 'IR', sample: ir);
        writeToL2AndSwapIfNeeded(channel: 'RED', sample: red);
        writeToL2AndSwapIfNeeded(channel: 'GREEN', sample: grn);
      }
    });
    await Future.delayed(const Duration(milliseconds: 50));
  }
}

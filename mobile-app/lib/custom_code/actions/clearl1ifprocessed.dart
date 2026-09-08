// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// lib/custom_code/actions/clearl1ifprocessed.dart

Future<void> clearl1ifprocessed(String channel) async {
  FFAppState().update(() {
    void swapIfNeeded(String ch) {
      if (ch == 'IR') {
        // clear L1
        FFAppState().ppgIRL1 = <int>[];
        // swap if L2 is full
        if (FFAppState().ppgIRL2.length >= 50 && FFAppState().ppgIRL1.isEmpty) {
          FFAppState().ppgIRL1 = List<int>.from(FFAppState().ppgIRL2);
          FFAppState().ppgIRL2 = <int>[];
        }
      } else if (ch == 'RED') {
        FFAppState().ppgRedL1 = <int>[];
        if (FFAppState().ppgRedL2.length >= 50 &&
            FFAppState().ppgRedL1.isEmpty) {
          FFAppState().ppgRedL1 = List<int>.from(FFAppState().ppgRedL2);
          FFAppState().ppgRedL2 = <int>[];
        }
      } else if (ch == 'GREEN') {
        FFAppState().ppgGreenL1 = <int>[];
        if (FFAppState().ppgGreenL2.length >= 50 &&
            FFAppState().ppgGreenL1.isEmpty) {
          FFAppState().ppgGreenL1 = List<int>.from(FFAppState().ppgGreenL2);
          FFAppState().ppgGreenL2 = <int>[];
        }
      }
    }

    final c = channel.toUpperCase();
    if (c == 'ALL') {
      swapIfNeeded('IR');
      swapIfNeeded('RED');
      swapIfNeeded('GREEN');
    } else if (c == 'IR' || c == 'RED' || c == 'GREEN') {
      swapIfNeeded(c);
    }
  });
}

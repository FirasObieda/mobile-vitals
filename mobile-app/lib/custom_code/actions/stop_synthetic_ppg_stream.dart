// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<void> stopSyntheticPpgStream(BuildContext context) async {
  if (!FFAppState().isPpgRunning) return;

  // Flipping this to false makes the loop in startSyntheticPpgStream exit
  FFAppState().update(() => FFAppState().isPpgRunning = false);
}

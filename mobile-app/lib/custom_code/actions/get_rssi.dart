// Automatic FlutterFlow imports
import '/app_state.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<int> getRssi(BTDeviceStruct deviceInfo) async {
  var deviceId = deviceInfo.id;
  if (deviceId == null || deviceId.isEmpty) {
    deviceId = FFAppState().activeBleDevice?.id ?? '';
  }
  if (deviceId.isEmpty) {
    debugPrint('getRssi skipped: missing device id');
    return -1;
  }
  final device = BluetoothDevice.fromId(deviceId);
  try {
    final retrievedRssi = await device.readRssi();
    FFAppState().update(() {
      FFAppState().latestBleRssi = retrievedRssi;
    });
    return retrievedRssi;
  } catch (e) {
    debugPrint('getRssi error: $e');
    return -1;
  }
}

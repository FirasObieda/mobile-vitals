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

// Automatic FlutterFlow importss

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future disconnectDevice(BTDeviceStruct deviceInfo) async {
  final deviceId = deviceInfo.id;
  if (deviceId == null || deviceId.isEmpty) {
    debugPrint('disconnectDevice skipped: missing device id');
    return;
  }
  final device = BluetoothDevice.fromId(deviceId);
  try {
    await device.disconnect();
    await stopBleReceiveLoop();
    FFAppState().update(() {
      FFAppState().bleStreaming = false;
      FFAppState().activeBleDevice = null;
      FFAppState().latestBleRssi = -120;
      FFAppState().lastBleConnectedAt = null;
    });
  } catch (e) {
    debugPrint(e.toString());
  }
}

// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// UUIDs must match the firmware running on the wearable.
const String _kVitalsServiceUuid = '12345678-1234-1234-1234-1234567890ab';
const String _kVitalsCharacteristicUuid =
    'abcd0004-5678-90ab-cdef-1234567890ab';

Future<void> sendVitalsToConnectedDevices({
  int? bpm,
  int? sbp,
  int? dbp,
  int? spo2,
}) async {
  final List<BluetoothDevice> connectedDevices =
      FlutterBluePlus.connectedDevices;
  if (connectedDevices.isEmpty) {
    return;
  }

  // Build a simple comma-separated payload, e.g. "72,118,76,97".
  final payload = [bpm, sbp, dbp, spo2]
      .map((value) => value?.toString() ?? '')
      .join(',');
  final data = utf8.encode(payload);

  for (final device in connectedDevices) {
    try {
      final services = await device.discoverServices();
      var wroteForDevice = false;
      for (final service in services) {
        if (service.uuid.toString().toLowerCase() !=
            _kVitalsServiceUuid.toLowerCase()) {
          continue;
        }
        for (final characteristic in service.characteristics) {
          final uuid = characteristic.uuid.toString().toLowerCase();
          if (uuid != _kVitalsCharacteristicUuid.toLowerCase()) {
            continue;
          }

          final supportsWrite = characteristic.properties.write;
          final supportsWriteWithoutResponse =
              characteristic.properties.writeWithoutResponse;
          if (!supportsWrite && !supportsWriteWithoutResponse) {
            continue;
          }

          final withoutResponse = !supportsWrite && supportsWriteWithoutResponse;
          await characteristic.write(data, withoutResponse: withoutResponse);
          wroteForDevice = true;
          break;
        }
        if (wroteForDevice) {
          break;
        }
      }
    } catch (error) {
      debugPrint('sendVitalsToConnectedDevices error: $error');
    }
  }
}

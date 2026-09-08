// Automatic FlutterFlow imports
import 'dart:async';

import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<bool> _ensureBlePermissions() async {
  final permissions = <Permission>[
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.locationWhenInUse,
  ];

  final results = await permissions.request();
  return results.values
      .every((status) => status.isGranted || status.isLimited);
}

Future<List<BTDeviceStruct>> findDevices() async {
  final Map<String, BTDeviceStruct> seenDevices = {};
  if (!await _ensureBlePermissions()) {
    debugPrint('BLE scan aborted: missing permissions');
    return [];
  }

  StreamSubscription<List<ScanResult>>? subscription;
  try {
    subscription = FlutterBluePlus.scanResults.listen(
      (results) {
        for (final result in results) {
          final id = result.device.remoteId.toString();
          if (id.isEmpty) {
            continue;
          }

          final advName = result.advertisementData.advName.trim();
          final platformName = result.device.platformName.trim();
          final name = advName.isNotEmpty
              ? advName
              : (platformName.isNotEmpty ? platformName : id);

          seenDevices[id] = BTDeviceStruct(
            name: name,
            id: id,
            rssi: result.rssi,
          );
        }
      },
      onError: (e) => debugPrint('scanResults error: $e'),
    );

    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 4),
      androidUsesFineLocation: true,
    );

    await FlutterBluePlus.isScanning.where((val) => val == false).first;
  } catch (e) {
    debugPrint('findDevices error: $e');
  } finally {
    await subscription?.cancel();
  }

  return seenDevices.values.toList();
}

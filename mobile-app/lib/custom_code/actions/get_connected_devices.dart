// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

//

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<List<BTDeviceStruct>> getConnectedDevices() async {
  final List<BluetoothDevice> connectedDevs = FlutterBluePlus.connectedDevices;
  final List<BTDeviceStruct> deviceList = [];
  for (final dev in connectedDevs) {
    final id = dev.remoteId.toString();
    String name = dev.platformName;
    if (name.isEmpty) {
      name = 'Unknown';
    }
    deviceList.add(BTDeviceStruct(id: id, name: name));
  }
  return deviceList;
}

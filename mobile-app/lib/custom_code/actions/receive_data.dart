// Automatic FlutterFlow imports
import 'dart:async';

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

final Guid _ppgServiceUuid = Guid("12345678-1234-1234-1234-1234567890ab");
final Guid _ppgIrCharacteristicUuid =
  Guid("abcd0001-5678-90ab-cdef-1234567890ab");

BluetoothCharacteristic? _cachedCharacteristic;
String? _cachedCharacteristicDeviceId;
Timer? _receiveLoop;
Timer? _rssiTimer;
BTDeviceStruct? _loopDevice;
bool _isReading = false;
bool _isUploadingChunk = false;

bool _hasFullWindow() {
  return FFAppState().ppgIRL1.length >= 50 &&
      FFAppState().ppgRedL1.length >= 50 &&
      FFAppState().ppgGreenL1.length >= 50;
}

Future<void> _maybeUploadChunk() async {
  if (!_hasFullWindow() || _isUploadingChunk) {
    return;
  }
  _isUploadingChunk = true;
  try {
    await uploadppgtofirestorelive();
  } catch (e) {
    debugPrint('upload chunk error: $e');
  } finally {
    _isUploadingChunk = false;
  }
}

void _startRssiTimer() {
  _rssiTimer?.cancel();
  _rssiTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
    final device = FFAppState().activeBleDevice;
    if (device == null) {
      return;
    }
    await getRssi(device);
  });
}

void _stopRssiTimer() {
  _rssiTimer?.cancel();
  _rssiTimer = null;
}

Future<BluetoothCharacteristic?> _resolveCharacteristic(
    BluetoothDevice device) async {
  try {
    if (_cachedCharacteristic != null &&
        _cachedCharacteristicDeviceId == device.remoteId.toString()) {
      return _cachedCharacteristic;
    }

    final services = await device.discoverServices();
    // Prefer the explicit PPG characteristic
    for (final service in services) {
      if (service.uuid == _ppgServiceUuid) {
        for (final characteristic in service.characteristics) {
          if (characteristic.uuid == _ppgIrCharacteristicUuid) {
            _cachedCharacteristic = characteristic;
            _cachedCharacteristicDeviceId = device.remoteId.toString();
            return _cachedCharacteristic;
          }
        }
      }
    }
    // Fallback: first characteristic that supports read & notify
    for (final service in services) {
      for (final characteristic in service.characteristics) {
        if (characteristic.properties.read &&
            characteristic.properties.notify) {
          _cachedCharacteristic = characteristic;
          _cachedCharacteristicDeviceId = device.remoteId.toString();
          return _cachedCharacteristic;
        }
      }
    }
  } catch (e) {
    debugPrint('resolveCharacteristic error: $e');
  }
  return null;
}

Future<String?> receiveData(BTDeviceStruct deviceInfo) async {
  final deviceId = deviceInfo.id;
  if (deviceId == null || deviceId.isEmpty) {
    return null;
  }
  try {
    final device = BluetoothDevice.fromId(deviceId);
    final characteristic = await _resolveCharacteristic(device);
    if (characteristic == null) {
      return null;
    }
    final value = await characteristic.read();
    if (value.isEmpty) {
      return null;
    }
    return String.fromCharCodes(value);
  } catch (e) {
    debugPrint('receiveData error: $e');
    return null;
  }
}

Future<void> startBleReceiveLoop(BTDeviceStruct deviceInfo) async {
  final deviceId = deviceInfo.id;
  if (deviceId == null || deviceId.isEmpty) {
    debugPrint('startBleReceiveLoop skipped: missing device id');
    return;
  }
  final normalizedDevice = BTDeviceStruct(
    name: deviceInfo.name,
    id: deviceInfo.id,
    rssi: deviceInfo.rssi,
  );
  _loopDevice = normalizedDevice;
  FFAppState().update(() {
    FFAppState().activeBleDevice = normalizedDevice;
    FFAppState().bleStreaming = true;
  });
  _receiveLoop?.cancel();
  _receiveLoop = Timer.periodic(const Duration(milliseconds: 250), (_) async {
    if (_isReading || _loopDevice == null) {
      return;
    }
    _isReading = true;
    try {
      final sample = await receiveData(_loopDevice!);
      final trimmed = sample?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        FFAppState().update(() {
          FFAppState().latestBleSample = trimmed;
        });
        await ppgenqueuefromstring(trimmed);
          await _maybeUploadChunk();
      }
    } catch (e) {
      debugPrint('BLE loop read error: $e');
    } finally {
      _isReading = false;
    }
  });
  debugPrint('Started BLE receive loop for $deviceId');
  _startRssiTimer();
}

Future<void> stopBleReceiveLoop() async {
  _loopDevice = null;
  _receiveLoop?.cancel();
  _receiveLoop = null;
  _stopRssiTimer();
  FFAppState().update(() {
    FFAppState().bleStreaming = false;
  });
  debugPrint('Stopped BLE receive loop');
}

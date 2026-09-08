import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/backend/schema/structs/index.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  static const String _kVitalAlertsPrefsKey = 'ff_vital_alerts';

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  SharedPreferences? _prefs;

  static void reset() {
    _instance._clearPersistedState();
    _instance = FFAppState._internal();
  }

  Future<void> initializePersistedState() async {
    await _ensurePrefs();
    _loadVitalAlertsFromPrefs();
  }

  void _clearPersistedState() {
    _prefs?.remove(_kVitalAlertsPrefsKey);
  }

  Future<void> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  void _loadVitalAlertsFromPrefs() {
    final storedAlerts = _prefs?.getStringList(_kVitalAlertsPrefsKey);
    if (storedAlerts == null) {
      return;
    }

    final decodedAlerts = storedAlerts
        .map((alertJson) {
          try {
            final data = jsonDecode(alertJson) as Map<String, dynamic>;
            return VitalAlertStruct.fromSerializableMap(data);
          } catch (_) {
            return null;
          }
        })
        .whereType<VitalAlertStruct>()
        .toList();

    if (decodedAlerts.isEmpty) {
      return;
    }

    _vitalAlerts = decodedAlerts;
    notifyListeners();
  }

  void _persistVitalAlerts() {
    final prefs = _prefs;
    if (prefs == null) {
      SharedPreferences.getInstance().then((value) {
        _prefs = value;
        _persistVitalAlerts();
      });
      return;
    }

    final serializedAlerts = _vitalAlerts
        .map((alert) => alert.serialize())
        .toList();

    prefs.setStringList(_kVitalAlertsPrefsKey, serializedAlerts);
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  /// stores if user is connected to internet
  bool _Internet = false;
  bool get Internet => _Internet;
  set Internet(bool value) {
    _Internet = value;
  }

  /// stores most recent raw BLE sample broadcast by the ESP
  String _latestBleSample = '-';
  String get latestBleSample => _latestBleSample;
  set latestBleSample(String value) {
    _latestBleSample = value;
  }

  /// currently active BLE device info (if connected)
  BTDeviceStruct? _activeBleDevice;
  BTDeviceStruct? get activeBleDevice => _activeBleDevice;
  set activeBleDevice(BTDeviceStruct? value) {
    _activeBleDevice = value;
  }

  /// timestamp when the BLE device was most recently paired
  DateTime? _lastBleConnectedAt;
  DateTime? get lastBleConnectedAt => _lastBleConnectedAt;
  set lastBleConnectedAt(DateTime? value) {
    _lastBleConnectedAt = value;
  }

  /// flag indicating whether the background BLE stream is running
  bool _bleStreaming = false;
  bool get bleStreaming => _bleStreaming;
  set bleStreaming(bool value) {
    _bleStreaming = value;
  }

  /// last known RSSI for the active BLE device
  int _latestBleRssi = -120;
  int get latestBleRssi => _latestBleRssi;
  set latestBleRssi(int value) {
    _latestBleRssi = value;
  }

  List<VitalAlertStruct> _vitalAlerts = [];
  List<VitalAlertStruct> get vitalAlerts => _vitalAlerts;
  set vitalAlerts(List<VitalAlertStruct> value) {
    _vitalAlerts = value;
    _persistVitalAlerts();
  }

  void addToVitalAlerts(VitalAlertStruct value) {
    vitalAlerts = [...vitalAlerts, value];
  }

  void removeFromVitalAlerts(VitalAlertStruct value) {
    vitalAlerts =
        vitalAlerts.where((element) => element != value).toList();
  }

  void removeAtIndexFromVitalAlerts(int index) {
    if (index < 0 || index >= vitalAlerts.length) {
      return;
    }
    final updatedList = List<VitalAlertStruct>.from(vitalAlerts)
      ..removeAt(index);
    vitalAlerts = updatedList;
  }

  void updateVitalAlertsAtIndex(
    int index,
    VitalAlertStruct Function(VitalAlertStruct) updateFn,
  ) {
    if (index < 0 || index >= vitalAlerts.length) {
      return;
    }
    final updatedAlert = updateFn(vitalAlerts[index]);
    final updatedList = List<VitalAlertStruct>.from(vitalAlerts)
      ..[index] = updatedAlert;
    vitalAlerts = updatedList;
  }

  void insertAtIndexInVitalAlerts(int index, VitalAlertStruct value) {
    final insertIndex = index.clamp(0, vitalAlerts.length);
    final updatedList = List<VitalAlertStruct>.from(vitalAlerts)
      ..insert(insertIndex, value);
    vitalAlerts = updatedList;
  }

  List<int> _ppgIRL1 = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];
  List<int> get ppgIRL1 => _ppgIRL1;
  set ppgIRL1(List<int> value) {
    _ppgIRL1 = value;
  }

  void addToPpgIRL1(int value) {
    ppgIRL1.add(value);
  }

  void removeFromPpgIRL1(int value) {
    ppgIRL1.remove(value);
  }

  void removeAtIndexFromPpgIRL1(int index) {
    ppgIRL1.removeAt(index);
  }

  void updatePpgIRL1AtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    ppgIRL1[index] = updateFn(_ppgIRL1[index]);
  }

  void insertAtIndexInPpgIRL1(int index, int value) {
    ppgIRL1.insert(index, value);
  }

  List<int> _ppgGreenL1 = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];
  List<int> get ppgGreenL1 => _ppgGreenL1;
  set ppgGreenL1(List<int> value) {
    _ppgGreenL1 = value;
  }

  void addToPpgGreenL1(int value) {
    ppgGreenL1.add(value);
  }

  void removeFromPpgGreenL1(int value) {
    ppgGreenL1.remove(value);
  }

  void removeAtIndexFromPpgGreenL1(int index) {
    ppgGreenL1.removeAt(index);
  }

  void updatePpgGreenL1AtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    ppgGreenL1[index] = updateFn(_ppgGreenL1[index]);
  }

  void insertAtIndexInPpgGreenL1(int index, int value) {
    ppgGreenL1.insert(index, value);
  }

  List<int> _ppgRedL1 = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];
  List<int> get ppgRedL1 => _ppgRedL1;
  set ppgRedL1(List<int> value) {
    _ppgRedL1 = value;
  }

  void addToPpgRedL1(int value) {
    ppgRedL1.add(value);
  }

  void removeFromPpgRedL1(int value) {
    ppgRedL1.remove(value);
  }

  void removeAtIndexFromPpgRedL1(int index) {
    ppgRedL1.removeAt(index);
  }

  void updatePpgRedL1AtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    ppgRedL1[index] = updateFn(_ppgRedL1[index]);
  }

  void insertAtIndexInPpgRedL1(int index, int value) {
    ppgRedL1.insert(index, value);
  }


  List<int> _ppgIRL2 = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];
  List<int> get ppgIRL2 => _ppgIRL2;
  set ppgIRL2(List<int> value) {
    _ppgIRL2 = value;
  }

  void addToPpgIRL2(int value) {
    ppgIRL2.add(value);
  }

  void removeFromPpgIRL2(int value) {
    ppgIRL2.remove(value);
  }

  void removeAtIndexFromPpgIRL2(int index) {
    ppgIRL2.removeAt(index);
  }

  void updatePpgIRL2AtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    ppgIRL2[index] = updateFn(_ppgIRL2[index]);
  }

  void insertAtIndexInPpgIRL2(int index, int value) {
    ppgIRL2.insert(index, value);
  }

  List<int> _ppgGreenL2 = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];
  List<int> get ppgGreenL2 => _ppgGreenL2;
  set ppgGreenL2(List<int> value) {
    _ppgGreenL2 = value;
  }

  void addToPpgGreenL2(int value) {
    ppgGreenL2.add(value);
  }

  void removeFromPpgGreenL2(int value) {
    ppgGreenL2.remove(value);
  }

  void removeAtIndexFromPpgGreenL2(int index) {
    ppgGreenL2.removeAt(index);
  }

  void updatePpgGreenL2AtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    ppgGreenL2[index] = updateFn(_ppgGreenL2[index]);
  }

  void insertAtIndexInPpgGreenL2(int index, int value) {
    ppgGreenL2.insert(index, value);
  }

  List<int> _ppgRedL2 = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];
  List<int> get ppgRedL2 => _ppgRedL2;
  set ppgRedL2(List<int> value) {
    _ppgRedL2 = value;
  }

  void addToPpgRedL2(int value) {
    ppgRedL2.add(value);
  }

  void removeFromPpgRedL2(int value) {
    ppgRedL2.remove(value);
  }

  void removeAtIndexFromPpgRedL2(int index) {
    ppgRedL2.removeAt(index);
  }

  void updatePpgRedL2AtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    ppgRedL2[index] = updateFn(_ppgRedL2[index]);
  }

  void insertAtIndexInPpgRedL2(int index, int value) {
    ppgRedL2.insert(index, value);
  }


  /// Used for testing
  bool _syntheticRunning = false;
  bool get syntheticRunning => _syntheticRunning;
  set syntheticRunning(bool value) {
    _syntheticRunning = value;
  }

  int _ppgIRL2Index = 0;
  int get ppgIRL2Index => _ppgIRL2Index;
  set ppgIRL2Index(int value) {
    _ppgIRL2Index = value;
  }

  int _ppgRedL2Index = 0;
  int get ppgRedL2Index => _ppgRedL2Index;
  set ppgRedL2Index(int value) {
    _ppgRedL2Index = value;
  }

  int _ppgGreenL2Index = 0;
  int get ppgGreenL2Index => _ppgGreenL2Index;
  set ppgGreenL2Index(int value) {
    _ppgGreenL2Index = value;
  }

  int _ppgIRL1Count = 0;
  int get ppgIRL1Count => _ppgIRL1Count;
  set ppgIRL1Count(int value) {
    _ppgIRL1Count = value;
  }

  bool _isPpgRunning = false;
  bool get isPpgRunning => _isPpgRunning;
  set isPpgRunning(bool value) {
    _isPpgRunning = value;
  }

  int _ppgRedL1Count = 0;
  int get ppgRedL1Count => _ppgRedL1Count;
  set ppgRedL1Count(int value) {
    _ppgRedL1Count = value;
  }

  int _ppgGreenL1Count = 0;
  int get ppgGreenL1Count => _ppgGreenL1Count;
  set ppgGreenL1Count(int value) {
    _ppgGreenL1Count = value;
  }

  List<String> _weeklyLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  List<String> get weeklyLabels => _weeklyLabels;
  set weeklyLabels(List<String> value) {
    _weeklyLabels = value;
  }

  void addToWeeklyLabels(String value) {
    weeklyLabels.add(value);
  }

  void removeFromWeeklyLabels(String value) {
    weeklyLabels.remove(value);
  }

  void removeAtIndexFromWeeklyLabels(int index) {
    weeklyLabels.removeAt(index);
  }

  void updateWeeklyLabelsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    weeklyLabels[index] = updateFn(_weeklyLabels[index]);
  }

  void insertAtIndexInWeeklyLabels(int index, String value) {
    weeklyLabels.insert(index, value);
  }

  List<double> _weeklyHR = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> get weeklyHR => _weeklyHR;
  set weeklyHR(List<double> value) {
    _weeklyHR = value;
  }

  void addToWeeklyHR(double value) {
    weeklyHR.add(value);
  }

  void removeFromWeeklyHR(double value) {
    weeklyHR.remove(value);
  }

  void removeAtIndexFromWeeklyHR(int index) {
    weeklyHR.removeAt(index);
  }

  void updateWeeklyHRAtIndex(
    int index,
    double Function(double) updateFn,
  ) {
    weeklyHR[index] = updateFn(_weeklyHR[index]);
  }

  void insertAtIndexInWeeklyHR(int index, double value) {
    weeklyHR.insert(index, value);
  }

  List<double> _weeklySpO2 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> get weeklySpO2 => _weeklySpO2;
  set weeklySpO2(List<double> value) {
    _weeklySpO2 = value;
  }

  void addToWeeklySpO2(double value) {
    weeklySpO2.add(value);
  }

  void removeFromWeeklySpO2(double value) {
    weeklySpO2.remove(value);
  }

  void removeAtIndexFromWeeklySpO2(int index) {
    weeklySpO2.removeAt(index);
  }

  void updateWeeklySpO2AtIndex(
    int index,
    double Function(double) updateFn,
  ) {
    weeklySpO2[index] = updateFn(_weeklySpO2[index]);
  }

  void insertAtIndexInWeeklySpO2(int index, double value) {
    weeklySpO2.insert(index, value);
  }

  List<double> _weeklySBP = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> get weeklySBP => _weeklySBP;
  set weeklySBP(List<double> value) {
    _weeklySBP = value;
  }

  void addToWeeklySBP(double value) {
    weeklySBP.add(value);
  }

  void removeFromWeeklySBP(double value) {
    weeklySBP.remove(value);
  }

  void removeAtIndexFromWeeklySBP(int index) {
    weeklySBP.removeAt(index);
  }

  void updateWeeklySBPAtIndex(
    int index,
    double Function(double) updateFn,
  ) {
    weeklySBP[index] = updateFn(_weeklySBP[index]);
  }

  void insertAtIndexInWeeklySBP(int index, double value) {
    weeklySBP.insert(index, value);
  }

  List<double> _weeklyDBP = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> get weeklyDBP => _weeklyDBP;
  set weeklyDBP(List<double> value) {
    _weeklyDBP = value;
  }

  void addToWeeklyDBP(double value) {
    weeklyDBP.add(value);
  }

  void removeFromWeeklyDBP(double value) {
    weeklyDBP.remove(value);
  }

  void removeAtIndexFromWeeklyDBP(int index) {
    weeklyDBP.removeAt(index);
  }

  void updateWeeklyDBPAtIndex(
    int index,
    double Function(double) updateFn,
  ) {
    weeklyDBP[index] = updateFn(_weeklyDBP[index]);
  }

  void insertAtIndexInWeeklyDBP(int index, double value) {
    weeklyDBP.insert(index, value);
  }
}

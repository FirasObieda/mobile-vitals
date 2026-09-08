// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/app_state.dart';

Future<void> updateVitalAlertsFromVitals({
  int? bpm,
  int? sbp,
  int? dbp,
  int? spo2,
  DateTime? timestamp,
}) async {
  final List<VitalAlertStruct> newAlerts = [];
  final DateTime stampedAt = timestamp ?? DateTime.now();

  String fmtValue(int value, {String unit = ''}) {
    final formatted = value.toString();
    return unit.isEmpty ? formatted : '$formatted $unit';
  }

  void addAlert({
    required String title,
    required String message,
    String severity = 'warning',
  }) {
    newAlerts.add(createVitalAlertStruct(
      title: title,
      message: message,
      severity: severity,
      timestamp: stampedAt,
    ));
  }

  bool hasMeasurement(int? value) => value != null && value > 0;

  if (hasMeasurement(bpm)) {
    final hr = bpm!;
    if (hr >= 100) {
      addAlert(
        title: 'Elevated Heart Rate',
        message:
            'Your heart rate is ${fmtValue(hr, unit: 'BPM')}, which is above the recommended resting range (50-99 BPM).',
        severity: 'critical',
      );
    } else if (hr <= 50) {
      addAlert(
        title: 'Low Heart Rate',
        message:
            'Your heart rate is ${fmtValue(hr, unit: 'BPM')}, which is below the typical resting range (50-99 BPM).',
        severity: 'warning',
      );
    }
  }

  if (hasMeasurement(sbp) && hasMeasurement(dbp)) {
    final systolic = sbp!;
    final diastolic = dbp!;
    if (systolic >= 140 || diastolic >= 90) {
      addAlert(
        title: 'High Blood Pressure',
        message:
            'Your blood pressure is ${fmtValue(systolic)}/${fmtValue(diastolic)} mmHg, indicating hypertension. Please consult your healthcare provider.',
        severity: 'critical',
      );
    } else if (systolic >= 120 || diastolic >= 80) {
      addAlert(
        title: 'Elevated Blood Pressure',
        message:
            'Your blood pressure is ${fmtValue(systolic)}/${fmtValue(diastolic)} mmHg, which is above the ideal range of 90-119/60-79 mmHg.',
        severity: 'warning',
      );
    } else if (systolic <= 90 || diastolic <= 60) {
      addAlert(
        title: 'Low Blood Pressure',
        message:
            'Your blood pressure is ${fmtValue(systolic)}/${fmtValue(diastolic)} mmHg, which is below the normal range. Monitor for dizziness or fatigue.',
        severity: 'info',
      );
    }
  }

  if (hasMeasurement(spo2)) {
    final oxygen = spo2!;
    if (oxygen < 94) {
      addAlert(
        title: 'Low Blood Oxygen',
        message:
            'Your SpO₂ level is ${fmtValue(oxygen, unit: '%')}, which is below the healthy range (94-100%). Consider resting and consulting a clinician if symptoms persist.',
        severity: 'critical',
      );
    } else if (oxygen < 96) {
      addAlert(
        title: 'Borderline Blood Oxygen',
        message:
            'Your SpO₂ level is ${fmtValue(oxygen, unit: '%')}. Although acceptable, it is slightly below the optimal 96-100% range.',
        severity: 'warning',
      );
    }
  }

  if (newAlerts.isEmpty) {
    return;
  }

  String alertKey(VitalAlertStruct alert) => [
        alert.severity.toLowerCase(),
        alert.title.toLowerCase(),
        alert.message.toLowerCase(),
      ].join('|');

  final appState = FFAppState();
  final existingAlerts = List<VitalAlertStruct>.from(appState.vitalAlerts);
  final Map<String, int> existingOrder = {
    for (var i = 0; i < existingAlerts.length; i++)
      alertKey(existingAlerts[i]): i,
  };
  final Map<String, VitalAlertStruct> mergedAlerts = {
    for (final alert in existingAlerts) alertKey(alert): alert,
  };
  final Map<String, int> newAlertOrder = {};
  final Set<String> newAlertKeys = <String>{};

  var hasChanges = false;

  for (final alert in newAlerts) {
    final normalizedAlert = alert.copyWith(
      timestamp: alert.timestamp ?? stampedAt,
    );
    final key = alertKey(normalizedAlert);
    final existing = mergedAlerts[key];

    if (existing != null) {
      final existingTimestamp = existing.timestamp;
      final normalizedTimestamp = normalizedAlert.timestamp;

      // If we already have this alert with a newer or same timestamp, skip.
      if (existingTimestamp != null &&
          normalizedTimestamp != null &&
          !normalizedTimestamp.isAfter(existingTimestamp)) {
        continue;
      }
    }

    if (existing == null) {
      mergedAlerts[key] = normalizedAlert;
      newAlertKeys.add(key);
      newAlertOrder[key] = newAlertOrder.length;
      hasChanges = true;
      continue;
    }

    mergedAlerts[key] = existing.copyWith(
      title: normalizedAlert.title,
      message: normalizedAlert.message,
      severity: normalizedAlert.severity,
      timestamp: normalizedAlert.timestamp,
    );
    hasChanges = true;
  }

  if (!hasChanges) {
    return;
  }

  final mergedList = mergedAlerts.entries.toList()
    ..sort((aEntry, bEntry) {
      final aAlert = aEntry.value;
      final bAlert = bEntry.value;
      final aTime =
          aAlert.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime =
          bAlert.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
      final timeComparison = bTime.compareTo(aTime);
      if (timeComparison != 0) {
        return timeComparison;
      }

      final aIsNew = newAlertKeys.contains(aEntry.key);
      final bIsNew = newAlertKeys.contains(bEntry.key);
      if (aIsNew != bIsNew) {
        return aIsNew ? -1 : 1;
      }

      if (aIsNew && bIsNew) {
        final aOrder = newAlertOrder[aEntry.key] ?? 0;
        final bOrder = newAlertOrder[bEntry.key] ?? 0;
        return aOrder.compareTo(bOrder);
      }

      final aOrder = existingOrder[aEntry.key] ?? existingAlerts.length;
      final bOrder = existingOrder[bEntry.key] ?? existingAlerts.length;
      return aOrder.compareTo(bOrder);
    });

  final orderedAlerts = mergedList.map((entry) => entry.value).toList();

  appState.update(() {
    appState.vitalAlerts = orderedAlerts;
  });
}

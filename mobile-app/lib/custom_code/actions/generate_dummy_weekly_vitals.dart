// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';
import 'package:intl/intl.dart';

Future<void> generateDummyWeeklyVitals() async {
  // Dev utility to inject deterministic-looking vitals for chart testing only.
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day)
      .subtract(const Duration(days: 6));
  final rnd = Random();

  String formatDay(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  double nextValue(double base, double jitter) {
    final value = base + rnd.nextDouble() * jitter;
    return double.parse(value.toStringAsFixed(1));
  }

  final labels = <String>[];
  final hr = <double>[];
  final spo2 = <double>[];
  final sbp = <double>[];
  final dbp = <double>[];

  for (var i = 0; i < 7; i++) {
    final day = start.add(Duration(days: i));
    labels.add(formatDay(day));
  hr.add(nextValue((62 + rnd.nextInt(18)).toDouble(), 4.0));
  spo2.add(nextValue((94 + rnd.nextInt(4)).toDouble(), 2.0));
  sbp.add(nextValue((108 + rnd.nextInt(22)).toDouble(), 6.0));
  dbp.add(nextValue((68 + rnd.nextInt(12)).toDouble(), 4.0));
  }

  FFAppState().update(() {
    FFAppState().weeklyLabels = labels;
    FFAppState().weeklyHR = hr;
    FFAppState().weeklySpO2 = spo2;
    FFAppState().weeklySBP = sbp;
    FFAppState().weeklyDBP = dbp;
  });

  debugPrint('Dummy weekly vitals injected for testing charts.');
}

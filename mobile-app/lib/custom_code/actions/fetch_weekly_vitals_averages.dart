// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// lib/custom_code/actions/fetch_weekly_vitals_averages.dart

import 'index.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:intl/intl.dart';

Future<void> fetchWeeklyVitalsAverages() async {
  try {
    // 1) 7-day window: local midnight today back to 6 days ago
    final now = DateTime.now();
    final windowStart =
        DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
    final windowEnd = windowStart.add(const Duration(days: 7));

    final userRef = currentUserReference;
    if (userRef == null) {
      throw StateError('fetchWeeklyVitalsAverages: no authenticated user');
    }

    // 2) Query this user's vitals within the 7-day window
    final snap = await userRef
        .collection('HealthVitals')
        .where('updatedAt', isGreaterThanOrEqualTo: windowStart)
        .where('updatedAt', isLessThan: windowEnd)
        .orderBy('updatedAt')
        .get();

    // 3) Buckets (0..6)
    final hr = List<double>.filled(7, 0);
    final spo2 = List<double>.filled(7, 0);
    final sbp = List<double>.filled(7, 0);
    final dbp = List<double>.filled(7, 0);
    final n = List<int>.filled(7, 0);

    double dnum(dynamic v) => (v is num) ? v.toDouble() : 0.0;

    for (final doc in snap.docs) {
      final data = doc.data();
      final tm = data['updatedAt'];
      DateTime? t;
      if (tm is Timestamp) t = tm.toDate();
      if (tm is DateTime) t = tm;
      if (t == null) continue;

      final idx = t.difference(windowStart).inDays;
      if (idx < 0 || idx > 6) continue;

      final _hr = dnum(data['BPM']);
      final _sbp = dnum(data['SBP']);
      final _dbp = dnum(data['DBP']);
      final _sp = dnum(data['SpO2']);

      hr[idx] += _hr;
      sbp[idx] += _sbp;
      dbp[idx] += _dbp;
      spo2[idx] += _sp;
      n[idx] += 1;
    }

    List<double> avg(List<double> s, List<int> c) => List<double>.generate(
        7,
        (i) =>
            c[i] == 0 ? 0.0 : double.parse((s[i] / c[i]).toStringAsFixed(1)));

    final outHR = avg(hr, n);
    final outSBP = avg(sbp, n);
    final outDBP = avg(dbp, n);
    final outSpO2 = avg(spo2, n);

    // 4) ISO labels
    final df = DateFormat('yyyy-MM-dd');
    final labels = List<String>.generate(7, (i) {
      final d = windowStart.add(Duration(days: i));
      return df.format(d);
    });

    // 5) Write to App State (always 7 items)
    FFAppState().update(() {
      FFAppState().weeklyLabels = labels;
      FFAppState().weeklyHR = outHR;
      FFAppState().weeklySBP = outSBP;
      FFAppState().weeklyDBP = outDBP;
      FFAppState().weeklySpO2 = outSpO2;
    });

    print('HealthVitals rows: ${snap.size} '
        'labels=${labels.length} HR=${outHR.length} SBP=${outSBP.length} DBP=${outDBP.length} SpO2=${outSpO2.length}');
  } catch (e) {
    print('fetchWeeklyVitalsAverages error: $e');
    // Keep lengths 7 to avoid chart assertion
    FFAppState().update(() {
      FFAppState().weeklyLabels = const ['', '', '', '', '', '', ''];
      FFAppState().weeklyHR = const [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      FFAppState().weeklySBP = const [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      FFAppState().weeklyDBP = const [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      FFAppState().weeklySpO2 = const [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    });
  }
}

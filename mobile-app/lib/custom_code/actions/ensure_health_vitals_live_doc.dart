// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

Future<void> ensureHealthVitalsLiveDoc({bool forceReset = false}) async {
  final userRef = currentUserReference;
  if (userRef == null) {
    return;
  }

  final liveDocRef = userRef.collection('HealthVitals').doc('live');
  final defaultPayload = <String, dynamic>{
    'BPM': 0.0,
    'SBP': 0.0,
    'DBP': 0.0,
    'SpO2': 0.0,
    'userRef': userRef,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  if (forceReset) {
    await liveDocRef.set(defaultPayload, SetOptions(merge: false));
    return;
  }

  final snapshot = await liveDocRef.get();

  final Map<String, dynamic> updates = <String, dynamic>{};

  if (!snapshot.exists) {
    updates.addAll(defaultPayload);
  } else {
    final data = snapshot.data() as Map<String, dynamic>? ?? <String, dynamic>{};
    final DocumentReference<Object?>? existingUserRef =
        data['userRef'] as DocumentReference<Object?>?;

    if (existingUserRef == null || existingUserRef.path != userRef.path) {
      updates['userRef'] = userRef;
    }

    if (!data.containsKey('updatedAt') || data['updatedAt'] == null ||
        data['updatedAt'] is! Timestamp) {
      updates['updatedAt'] = FieldValue.serverTimestamp();
    }

    const healthFields = <String, double>{
      'BPM': 0.0,
      'SBP': 0.0,
      'DBP': 0.0,
      'SpO2': 0.0,
    };

    for (final entry in healthFields.entries) {
      final key = entry.key;
      final defaultValue = entry.value;
      final rawValue = data[key];

      if (rawValue == null) {
        updates[key] = defaultValue;
        continue;
      }

      if (rawValue is num) {
        final doubleValue = rawValue.toDouble();
        if (rawValue is! double) {
          updates[key] = doubleValue;
        }
        continue;
      }

      if (rawValue is String) {
        final parsed = double.tryParse(rawValue);
        if (parsed != null) {
          updates[key] = parsed;
          continue;
        }
      }

      // Value exists but is not numeric; reset to default for data integrity.
      updates[key] = defaultValue;
    }
  }

  if (updates.isEmpty) {
    return;
  }

  await liveDocRef.set(updates, SetOptions(merge: true));
}

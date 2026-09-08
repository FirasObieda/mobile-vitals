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

Future<void> clearHealthVitalsOnSignup() async {
  final userRef = currentUserReference;
  if (userRef == null) {
    return;
  }

  const flagField = 'healthVitalsClearedOnSignup';

  final userSnapshot = await userRef.get();
  final userData =
      userSnapshot.data() as Map<String, dynamic>? ?? <String, dynamic>{};

  if (userData[flagField] == true) {
    return;
  }

  final vitalsSnapshot = await userRef.collection('HealthVitals').get();
  if (vitalsSnapshot.docs.isNotEmpty) {
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in vitalsSnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  await userRef.set(<String, dynamic>{flagField: true}, SetOptions(merge: true));
}

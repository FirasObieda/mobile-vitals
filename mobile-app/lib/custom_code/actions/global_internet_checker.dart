// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<void> globalInternetChecker() async {
  bool lastState = FFAppState().Internet;

  try {
    final bool isConnected = await InternetConnection().hasInternetAccess;

    if (lastState != isConnected) {
      FFAppState().Internet = isConnected;
      FFAppState().notifyListeners();
      print('Internet connection status updated: $isConnected');
    }
  } catch (e) {
    if (lastState != false) {
      FFAppState().Internet = false;
      FFAppState().notifyListeners();
      print('Error checking internet connection: $e');
    }
  }
}

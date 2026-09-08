// ignore_for_file: unnecessary_getters_setters

import 'package:collection/collection.dart';

import '/backend/schema/util/schema_util.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VitalAlertStruct extends BaseStruct {
  VitalAlertStruct({
    String? title,
    String? message,
    String? severity,
    DateTime? timestamp,
  })  : _title = title,
        _message = message,
        _severity = severity,
        _timestamp = timestamp;

  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;
  bool hasTitle() => _title != null;

  String? _message;
  String get message => _message ?? '';
  set message(String? val) => _message = val;
  bool hasMessage() => _message != null;

  String? _severity;
  String get severity => _severity ?? 'info';
  set severity(String? val) => _severity = val;
  bool hasSeverity() => _severity != null;

  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  set timestamp(DateTime? val) => _timestamp = val;
  bool hasTimestamp() => _timestamp != null;

  static VitalAlertStruct fromMap(Map<String, dynamic> data) => VitalAlertStruct(
        title: data['title'] as String?,
        message: data['message'] as String?,
        severity: data['severity'] as String?,
        timestamp: data['timestamp'] as DateTime?,
      );

  static VitalAlertStruct? maybeFromMap(dynamic data) => data is Map
      ? VitalAlertStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'message': _message,
        'severity': _severity,
        'timestamp': _timestamp,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'message': serializeParam(
          _message,
          ParamType.String,
        ),
        'severity': serializeParam(
          _severity,
          ParamType.String,
        ),
        'timestamp': serializeParam(
          _timestamp,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static VitalAlertStruct fromSerializableMap(Map<String, dynamic> data) =>
      VitalAlertStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        message: deserializeParam(
          data['message'],
          ParamType.String,
          false,
        ),
        severity: deserializeParam(
          data['severity'],
          ParamType.String,
          false,
        ),
        timestamp: deserializeParam(
          data['timestamp'],
          ParamType.DateTime,
          false,
        ),
      );

  VitalAlertStruct copyWith({
    String? title,
    String? message,
    String? severity,
    DateTime? timestamp,
  }) =>
      VitalAlertStruct(
        title: title ?? _title,
        message: message ?? _message,
        severity: severity ?? _severity,
        timestamp: timestamp ?? _timestamp,
      );

  @override
  String toString() => 'VitalAlertStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VitalAlertStruct &&
        title == other.title &&
        message == other.message &&
        severity == other.severity &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([title, message, severity, timestamp]);
}

VitalAlertStruct createVitalAlertStruct({
  String? title,
  String? message,
  String? severity,
  DateTime? timestamp,
}) =>
    VitalAlertStruct(
      title: title,
      message: message,
      severity: severity,
      timestamp: timestamp,
    );

List<VitalAlertStruct> createVitalAlertStructList(List<dynamic>? data) =>
    data?.map((e) => VitalAlertStruct.maybeFromMap(e) ?? VitalAlertStruct())
          .toList() ??
    [];

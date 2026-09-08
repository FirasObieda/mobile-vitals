import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HealthVitalsRecord extends FirestoreRecord {
  HealthVitalsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  int? _castToInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.round();
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  // "BPM" field.
  int? _bpm;

  /// Heart Rate
  int get bpm => _bpm ?? 0;
  bool hasBpm() => _bpm != null;

  // "SBP" field.
  int? _sbp;
  int get sbp => _sbp ?? 0;
  bool hasSbp() => _sbp != null;

  // "DBP" field.
  int? _dbp;
  int get dbp => _dbp ?? 0;
  bool hasDbp() => _dbp != null;

  // "SpO2" field.
  int? _spO2;
  int get spO2 => _spO2 ?? 0;
  bool hasSpO2() => _spO2 != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  // "userRef" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "test" field.
  int? _test;
  int get test => _test ?? 0;
  bool hasTest() => _test != null;

  void _initializeFields() {
  _bpm = _castToInt(snapshotData['BPM']);
  _sbp = _castToInt(snapshotData['SBP']);
  _dbp = _castToInt(snapshotData['DBP']);
  _spO2 = _castToInt(snapshotData['SpO2']);
    _updatedAt = snapshotData['updatedAt'] as DateTime?;
    _userRef = snapshotData['userRef'] as DocumentReference?;
    _test = castToType<int>(snapshotData['test']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('HealthVitals')
          : FirebaseFirestore.instance.collectionGroup('HealthVitals');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('HealthVitals').doc(id);

  static Stream<HealthVitalsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HealthVitalsRecord.fromSnapshot(s));

  static Future<HealthVitalsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => HealthVitalsRecord.fromSnapshot(s));

  static HealthVitalsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      HealthVitalsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static HealthVitalsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      HealthVitalsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HealthVitalsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HealthVitalsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createHealthVitalsRecordData({
  int? bpm,
  int? sbp,
  int? dbp,
  int? spO2,
  DateTime? updatedAt,
  DocumentReference? userRef,
  int? test,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'BPM': bpm,
      'SBP': sbp,
      'DBP': dbp,
      'SpO2': spO2,
      'updatedAt': updatedAt,
      'userRef': userRef,
      'test': test,
    }.withoutNulls,
  );

  return firestoreData;
}

class HealthVitalsRecordDocumentEquality
    implements Equality<HealthVitalsRecord> {
  const HealthVitalsRecordDocumentEquality();

  @override
  bool equals(HealthVitalsRecord? e1, HealthVitalsRecord? e2) {
    return e1?.bpm == e2?.bpm &&
        e1?.sbp == e2?.sbp &&
        e1?.dbp == e2?.dbp &&
        e1?.spO2 == e2?.spO2 &&
        e1?.updatedAt == e2?.updatedAt &&
        e1?.userRef == e2?.userRef &&
        e1?.test == e2?.test;
  }

  @override
  int hash(HealthVitalsRecord? e) => const ListEquality().hash([
        e?.bpm,
        e?.sbp,
        e?.dbp,
        e?.spO2,
        e?.updatedAt,
        e?.userRef,
        e?.test
      ]);

  @override
  bool isValidKey(Object? o) => o is HealthVitalsRecord;
}

// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class TOSCheckboxStruct extends FFFirebaseStruct {
  TOSCheckboxStruct({
    bool? tOSCheckbox,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _tOSCheckbox = tOSCheckbox,
        super(firestoreUtilData);

  // "TOS_Checkbox" field.
  bool? _tOSCheckbox;
  bool get tOSCheckbox => _tOSCheckbox ?? false;
  set tOSCheckbox(bool? val) => _tOSCheckbox = val;

  bool hasTOSCheckbox() => _tOSCheckbox != null;

  static TOSCheckboxStruct fromMap(Map<String, dynamic> data) =>
      TOSCheckboxStruct(
        tOSCheckbox: data['TOS_Checkbox'] as bool?,
      );

  static TOSCheckboxStruct? maybeFromMap(dynamic data) => data is Map
      ? TOSCheckboxStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'TOS_Checkbox': _tOSCheckbox,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'TOS_Checkbox': serializeParam(
          _tOSCheckbox,
          ParamType.bool,
        ),
      }.withoutNulls;

  static TOSCheckboxStruct fromSerializableMap(Map<String, dynamic> data) =>
      TOSCheckboxStruct(
        tOSCheckbox: deserializeParam(
          data['TOS_Checkbox'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'TOSCheckboxStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TOSCheckboxStruct && tOSCheckbox == other.tOSCheckbox;
  }

  @override
  int get hashCode => const ListEquality().hash([tOSCheckbox]);
}

TOSCheckboxStruct createTOSCheckboxStruct({
  bool? tOSCheckbox,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TOSCheckboxStruct(
      tOSCheckbox: tOSCheckbox,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

TOSCheckboxStruct? updateTOSCheckboxStruct(
  TOSCheckboxStruct? tOSCheckboxStruct, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    tOSCheckboxStruct
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTOSCheckboxStructData(
  Map<String, dynamic> firestoreData,
  TOSCheckboxStruct? tOSCheckboxStruct,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (tOSCheckboxStruct == null) {
    return;
  }
  if (tOSCheckboxStruct.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && tOSCheckboxStruct.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final tOSCheckboxStructData =
      getTOSCheckboxFirestoreData(tOSCheckboxStruct, forFieldValue);
  final nestedData =
      tOSCheckboxStructData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = tOSCheckboxStruct.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTOSCheckboxFirestoreData(
  TOSCheckboxStruct? tOSCheckboxStruct, [
  bool forFieldValue = false,
]) {
  if (tOSCheckboxStruct == null) {
    return {};
  }
  final firestoreData = mapToFirestore(tOSCheckboxStruct.toMap());

  // Add any Firestore field values
  tOSCheckboxStruct.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTOSCheckboxListFirestoreData(
  List<TOSCheckboxStruct>? tOSCheckboxStructs,
) =>
    tOSCheckboxStructs
        ?.map((e) => getTOSCheckboxFirestoreData(e, true))
        .toList() ??
    [];

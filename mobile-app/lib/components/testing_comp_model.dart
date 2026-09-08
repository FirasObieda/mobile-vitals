import '/flutter_flow/flutter_flow_util.dart';
import 'testing_comp_widget.dart' show TestingCompWidget;
import 'package:flutter/material.dart';

class TestingCompModel extends FlutterFlowModel<TestingCompWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for BPM widget.
  FocusNode? bpmFocusNode;
  TextEditingController? bpmTextController;
  String? Function(BuildContext, String?)? bpmTextControllerValidator;
  // State field(s) for SBP widget.
  FocusNode? sbpFocusNode;
  TextEditingController? sbpTextController;
  String? Function(BuildContext, String?)? sbpTextControllerValidator;
  // State field(s) for DBP widget.
  FocusNode? dbpFocusNode;
  TextEditingController? dbpTextController;
  String? Function(BuildContext, String?)? dbpTextControllerValidator;
  // State field(s) for SpO2 widget.
  FocusNode? spO2FocusNode;
  TextEditingController? spO2TextController;
  String? Function(BuildContext, String?)? spO2TextControllerValidator;
  // State field(s) for BMPAVG widget.
  FocusNode? bmpavgFocusNode;
  TextEditingController? bmpavgTextController;
  String? Function(BuildContext, String?)? bmpavgTextControllerValidator;
  // State field(s) for SBPAVG widget.
  FocusNode? sbpavgFocusNode;
  TextEditingController? sbpavgTextController;
  String? Function(BuildContext, String?)? sbpavgTextControllerValidator;
  // State field(s) for DBPAVG widget.
  FocusNode? dbpavgFocusNode;
  TextEditingController? dbpavgTextController;
  String? Function(BuildContext, String?)? dbpavgTextControllerValidator;
  // State field(s) for SpO2AVG widget.
  FocusNode? spO2AVGFocusNode;
  TextEditingController? spO2AVGTextController;
  String? Function(BuildContext, String?)? spO2AVGTextControllerValidator;
  // State field(s) for AlertType widget.
  FocusNode? alertTypeFocusNode;
  TextEditingController? alertTypeTextController;
  String? Function(BuildContext, String?)? alertTypeTextControllerValidator;
  // State field(s) for AlertTime widget.
  FocusNode? alertTimeFocusNode;
  TextEditingController? alertTimeTextController;
  String? Function(BuildContext, String?)? alertTimeTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    bpmFocusNode?.dispose();
    bpmTextController?.dispose();

    sbpFocusNode?.dispose();
    sbpTextController?.dispose();

    dbpFocusNode?.dispose();
    dbpTextController?.dispose();

    spO2FocusNode?.dispose();
    spO2TextController?.dispose();

    bmpavgFocusNode?.dispose();
    bmpavgTextController?.dispose();

    sbpavgFocusNode?.dispose();
    sbpavgTextController?.dispose();

    dbpavgFocusNode?.dispose();
    dbpavgTextController?.dispose();

    spO2AVGFocusNode?.dispose();
    spO2AVGTextController?.dispose();

    alertTypeFocusNode?.dispose();
    alertTypeTextController?.dispose();

    alertTimeFocusNode?.dispose();
    alertTimeTextController?.dispose();
  }
}

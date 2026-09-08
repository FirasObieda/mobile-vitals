import '/components/testing_comp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'testing_page_widget.dart' show TestingPageWidget;
import 'package:flutter/material.dart';

class TestingPageModel extends FlutterFlowModel<TestingPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TestingComp component.
  late TestingCompModel testingCompModel;

  @override
  void initState(BuildContext context) {
    testingCompModel = createModel(context, () => TestingCompModel());
  }

  @override
  void dispose() {
    testingCompModel.dispose();
  }
}

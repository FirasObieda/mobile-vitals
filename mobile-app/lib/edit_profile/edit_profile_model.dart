import '/components/edit_profile_comp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'edit_profile_widget.dart' show EditProfileWidget;
import 'package:flutter/material.dart';

class EditProfileModel extends FlutterFlowModel<EditProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for EditProfileComp component.
  late EditProfileCompModel editProfileCompModel;

  @override
  void initState(BuildContext context) {
    editProfileCompModel = createModel(context, () => EditProfileCompModel());
  }

  @override
  void dispose() {
    editProfileCompModel.dispose();
  }
}

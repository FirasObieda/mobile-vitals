import '/flutter_flow/flutter_flow_util.dart';
import 'edit_profile_comp_widget.dart' show EditProfileCompWidget;
import 'package:flutter/material.dart';

class EditProfileCompModel extends FlutterFlowModel<EditProfileCompWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_uploadData9ss = false;
  FFUploadedFile uploadedLocalFile_uploadData9ss =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadData9ss = '';

  // State field(s) for FirstName widget.
  FocusNode? firstNameFocusNode;
  TextEditingController? firstNameTextController;
  String? Function(BuildContext, String?)? firstNameTextControllerValidator;
  // State field(s) for LastName widget.
  FocusNode? lastNameFocusNode;
  TextEditingController? lastNameTextController;
  String? Function(BuildContext, String?)? lastNameTextControllerValidator;
  // State field(s) for Age widget.
  FocusNode? ageFocusNode;
  TextEditingController? ageTextController;
  String? Function(BuildContext, String?)? ageTextControllerValidator;
  // State field(s) for Gender widget.
  FocusNode? genderFocusNode;
  TextEditingController? genderTextController;
  String? Function(BuildContext, String?)? genderTextControllerValidator;
  // State field(s) for Weight widget.
  FocusNode? weightFocusNode;
  TextEditingController? weightTextController;
  String? Function(BuildContext, String?)? weightTextControllerValidator;
  // State field(s) for Height widget.
  FocusNode? heightFocusNode;
  TextEditingController? heightTextController;
  String? Function(BuildContext, String?)? heightTextControllerValidator;
  // State field(s) for Condition widget.
  FocusNode? conditionFocusNode;
  TextEditingController? conditionTextController;
  String? Function(BuildContext, String?)? conditionTextControllerValidator;
  // State field(s) for myBio widget.
  FocusNode? myBioFocusNode;
  TextEditingController? myBioTextController;
  String? Function(BuildContext, String?)? myBioTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    firstNameFocusNode?.dispose();
    firstNameTextController?.dispose();

    lastNameFocusNode?.dispose();
    lastNameTextController?.dispose();

    ageFocusNode?.dispose();
    ageTextController?.dispose();

    genderFocusNode?.dispose();
    genderTextController?.dispose();

    weightFocusNode?.dispose();
    weightTextController?.dispose();

    heightFocusNode?.dispose();
    heightTextController?.dispose();

    conditionFocusNode?.dispose();
    conditionTextController?.dispose();

    myBioFocusNode?.dispose();
    myBioTextController?.dispose();
  }
}

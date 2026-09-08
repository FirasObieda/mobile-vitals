import '/components/account_details_comp_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'account_details_widget.dart' show AccountDetailsWidget;
import 'package:flutter/material.dart';

class AccountDetailsModel extends FlutterFlowModel<AccountDetailsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AccountDetailsComp component.
  late AccountDetailsCompModel accountDetailsCompModel;

  @override
  void initState(BuildContext context) {
    accountDetailsCompModel =
        createModel(context, () => AccountDetailsCompModel());
  }

  @override
  void dispose() {
    accountDetailsCompModel.dispose();
  }
}

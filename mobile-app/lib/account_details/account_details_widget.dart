import '/components/account_details_comp_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'account_details_model.dart';
export 'account_details_model.dart';

class AccountDetailsWidget extends StatefulWidget {
  const AccountDetailsWidget({super.key});

  static String routeName = 'AccountDetails';
  static String routePath = '/accountDetails';

  @override
  State<AccountDetailsWidget> createState() => _AccountDetailsWidgetState();
}

class _AccountDetailsWidgetState extends State<AccountDetailsWidget> {
  late AccountDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccountDetailsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.globalInternetChecker();
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF1B1F24),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, -1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
                      child: Container(
                        width: 350.0,
                        height: 750.0,
                        constraints: BoxConstraints(
                          maxWidth: 770.0,
                          maxHeight: double.infinity,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: wrapWithModel(
                          model: _model.accountDetailsCompModel,
                          updateCallback: () => safeSetState(() {}),
                          child: AccountDetailsCompWidget(
                            navigateAction: () async {},
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!FFAppState().Internet)
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 1.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      color: FlutterFlowTheme.of(context).alternate,
                      size: 100.0,
                    ),
                    Text(
                      'Please Check Your Internet Connection',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'App Font',
                            color: FlutterFlowTheme.of(context).alternate,
                            fontSize: 24.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

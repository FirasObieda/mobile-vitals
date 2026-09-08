import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_bar_top_model.dart';
export 'app_bar_top_model.dart';

class AppBarTopWidget extends StatefulWidget {
  const AppBarTopWidget({
    super.key,
    required this.backButtonAction,
    required this.title,
    this.secondIcon,
    this.secondButtonAction,
    required this.useSecondIcon,
    required this.backButtonIcon,
  });

  final Future Function()? backButtonAction;
  final String? title;
  final Widget? secondIcon;
  final Future Function()? secondButtonAction;
  final bool? useSecondIcon;
  final Widget? backButtonIcon;

  @override
  State<AppBarTopWidget> createState() => _AppBarTopWidgetState();
}

class _AppBarTopWidgetState extends State<AppBarTopWidget> {
  late AppBarTopModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppBarTopModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: 70.0,
      decoration: BoxDecoration(
        color: Color(0xFF070C10),
        boxShadow: [
          BoxShadow(
            blurRadius: 6.0,
            color: Color(0x7C000000),
            offset: Offset(
              0.0,
              4.0,
            ),
            spreadRadius: 3.0,
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(0.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
                    child: FlutterFlowIconButton(
                      borderRadius: 5.0,
                      borderWidth: 2.0,
                      buttonSize: 50.0,
                      icon: widget.backButtonIcon!,
                      onPressed: () async {
                        context.safePop();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  valueOrDefault<String>(
                    widget.title,
                    'none',
                  ),
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.roboto(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: Color(0xFFCECECD),
                        fontSize: 25.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
                  child: FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: 40.0,
                    disabledColor: Colors.transparent,
                    disabledIconColor: Colors.transparent,
                    icon: widget.secondIcon!,
                    onPressed: !widget.useSecondIcon!
                        ? null
                        : () async {
                            await widget.secondButtonAction?.call();
                          },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

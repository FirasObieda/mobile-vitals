import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/no_alerts_comp_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'alerts_model.dart';
export 'alerts_model.dart';

class AlertsWidget extends StatefulWidget {
  const AlertsWidget({super.key});

  static String routeName = 'Alerts';
  static String routePath = '/alerts';

  @override
  State<AlertsWidget> createState() => _AlertsWidgetState();
}

class _AlertsWidgetState extends State<AlertsWidget> {
  late AlertsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? _lastVitalsSignature;
  bool _clearedForMissingData = false;

  static const _pageBackgroundColor = Color(0xFF1B1F24);
  static const _cardBackgroundColor = Color(0xFF0B131A);
  static const _primaryTextColor = Color(0xFFCECECD);
  static const _secondaryTextColor = Color(0xFF8E9199);
  static const _cardShadowColor = Color(0x66000000);
  static const _borderColor = Color(0xFFE4E7EC);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlertsModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.globalInternetChecker();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _handleVitalsUpdate(HealthVitalsRecord record) {
    final signature = _buildVitalsSignature(record);
    if (_lastVitalsSignature == signature) {
      return;
    }
    _lastVitalsSignature = signature;
    _clearedForMissingData = false;

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.updateVitalAlertsFromVitals(
        bpm: record.hasBpm() ? record.bpm : null,
        sbp: record.hasSbp() ? record.sbp : null,
        dbp: record.hasDbp() ? record.dbp : null,
        spo2: record.hasSpO2() ? record.spO2 : null,
        timestamp: record.updatedAt,
      );
    });
  }

  String _buildVitalsSignature(HealthVitalsRecord record) {
    final updatedMicros = record.updatedAt?.microsecondsSinceEpoch ?? 0;
    return [
      record.hasBpm() ? record.bpm.toString() : 'null',
      record.hasSbp() ? record.sbp.toString() : 'null',
      record.hasDbp() ? record.dbp.toString() : 'null',
      record.hasSpO2() ? record.spO2.toString() : 'null',
      updatedMicros.toString(),
    ].join('|');
  }

  void _clearAlertsForMissingData() {
    if (_clearedForMissingData) {
      return;
    }
    _clearedForMissingData = true;
    _lastVitalsSignature = null;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (FFAppState().vitalAlerts.isEmpty) {
        return;
      }
      FFAppState().update(() {
        FFAppState().vitalAlerts = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final userRef = currentUserReference;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _pageBackgroundColor,
        body: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 900.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            30.0, 40.0, 30.0, 0.0),
                        child: Text(
                          'Alerts',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.roboto(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: _primaryTextColor,
                                fontSize: 40.0,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            30.0, 12.0, 30.0, 0.0),
                        child: Text(
                          'We will let you know when something needs attention.',
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                font: GoogleFonts.roboto(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                color: _secondaryTextColor,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              30.0, 30.0, 30.0, 30.0),
                          child: StreamBuilder<List<HealthVitalsRecord>>(
                            stream: userRef != null
                                ? queryHealthVitalsRecord(
                                    parent: userRef,
                                    queryBuilder: (query) => query.orderBy(
                                      'updatedAt',
                                      descending: true,
                                    ),
                                    singleRecord: true,
                                  )
                                : null,
                            builder: (context, snapshot) {
                              if (userRef == null) {
                                _clearAlertsForMissingData();
                                return const Center(
                                  child: NoAlertsCompWidget(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Failed to load alerts.',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.roboto(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: _primaryTextColor,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .fontStyle,
                                        ),
                                  ),
                                );
                              }
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 40.0,
                                    height: 40.0,
                                    child: SpinKitFadingFour(
                                      color: const Color(0xFF438FE4),
                                      size: 40.0,
                                    ),
                                  ),
                                );
                              }
                              final vitalsList = snapshot.data!;
                              final vitalsRecord = vitalsList.isNotEmpty
                                  ? vitalsList.first
                                  : null;

                              if (vitalsRecord != null) {
                                _handleVitalsUpdate(vitalsRecord);
                              } else {
                                _clearAlertsForMissingData();
                              }

                              final alerts = FFAppState().vitalAlerts;

                              if (alerts.isEmpty) {
                                return const Center(
                                  child: NoAlertsCompWidget(),
                                );
                              }

                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: alerts.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12.0),
                                itemBuilder: (context, index) {
                                  final alert = alerts[index];
                                  final severity =
                                      alert.severity.toLowerCase();
                                  final Color accentColor;
                                  final IconData iconData;
                                  switch (severity) {
                                    case 'critical':
                                      accentColor =
                                          const Color(0xFFE25555);
                                      iconData = Icons.error_outline;
                                      break;
                                    case 'warning':
                                      accentColor =
                                          const Color(0xFFF5A623);
                                      iconData =
                                          Icons.warning_amber_rounded;
                                      break;
                                    default:
                                      accentColor =
                                          const Color(0xFF438FE4);
                                      iconData = Icons.info_outline;
                                      break;
                                  }

                                  final timestampText = alert.hasTimestamp()
                                      ? '${dateTimeFormat('EEE', alert.timestamp!)}  ${dateTimeFormat('d/M/y', alert.timestamp!)}'
                                      : 'Updated just now';

                                  final dismissKey = ValueKey(
                                    'vital-alert-${alert.title}-${alert.severity}-${alert.timestamp?.microsecondsSinceEpoch ?? 0}-$index',
                                  );

                                  Widget buildDismissBackground(
                                    AlignmentGeometry alignment,
                                  ) {
                                    return Container(
                                      alignment: alignment,
                                      decoration: BoxDecoration(
                                        color: accentColor.withValues(alpha: 0.16),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 24.0),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: accentColor,
                                        size: 24.0,
                                      ),
                                    );
                                  }

                                  return Dismissible(
                                    key: dismissKey,
                                    direction: DismissDirection.horizontal,
                                    background: buildDismissBackground(
                                      Alignment.centerLeft,
                                    ),
                                    secondaryBackground: buildDismissBackground(
                                      Alignment.centerRight,
                                    ),
                                    onDismissed: (_) {
                                      FFAppState().update(() {
                                        FFAppState().removeAtIndexFromVitalAlerts(
                                          index,
                                        );
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Alert dismissed',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.roboto(
                                                    fontWeight: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .fontWeight,
                                                    fontStyle: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .fontStyle,
                                                  ),
                                                  color: _primaryTextColor,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: _cardBackgroundColor,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _cardBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: _cardShadowColor,
                                            blurRadius: 12.0,
                                            offset: Offset(0.0, 6.0),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                16.0, 16.0, 16.0, 16.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: accentColor
                                                    .withValues(alpha: 0.16),
                                                shape: BoxShape.circle,
                                              ),
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Icon(
                                                iconData,
                                                color: accentColor,
                                                size: 24.0,
                                              ),
                                            ),
                                            const SizedBox(width: 16.0),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    alert.title,
                                                    style:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .override(
                                                              font:
                                                                  GoogleFonts
                                                                      .roboto(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                              ),
                                                                color: _primaryTextColor,
                                                              fontSize: 20.0,
                                                              letterSpacing: 0.0,
                                                            ),
                                                  ),
                                                  const SizedBox(height: 6.0),
                                                  Text(
                                                    alert.message,
                                                    style:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .override(
                                                              font:
                                                                  GoogleFonts
                                                                      .roboto(
                                                                fontWeight:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                fontStyle:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                              ),
                                                                color: _secondaryTextColor,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                            ),
                                                      softWrap: true,
                                                      maxLines: null,
                                                  ),
                                                  const SizedBox(height: 10.0),
                                                  Text(
                                                    timestampText,
                                                    style:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .override(
                                                              font:
                                                                  GoogleFonts
                                                                      .roboto(
                                                                fontWeight:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                fontStyle:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontStyle,
                                                              ),
                                                                color: _secondaryTextColor,
                                                              letterSpacing: 0.0,
                                                            ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            30.0, 0.0, 30.0, 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await showDialog<void>(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      title:
                                          const Text('All Alerts Dismissed'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              alertDialogContext),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                FFAppState().update(() {
                                  FFAppState().vitalAlerts = [];
                                });
                              },
                              child: const FaIcon(
                                FontAwesomeIcons.trashCan,
                                color: _primaryTextColor,
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!FFAppState().Internet)
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 1.0,
                decoration: BoxDecoration(
                  color: _pageBackgroundColor.withValues(alpha: 0.96),
                  border: Border.all(
                    color: _borderColor,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_off,
                      color: Color(0xFF438FE4),
                      size: 100.0,
                    ),
                    Text(
                      '\nPlease Check Your Internet Connection.\n\nRestart the App After Reconnecting to the Internet.',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.roboto(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: _primaryTextColor,
                            fontSize: 25.0,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
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

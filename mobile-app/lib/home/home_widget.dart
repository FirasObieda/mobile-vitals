import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'Home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? _lastVitalsBroadcastSignature;
  bool _clearInFlight = false;

  static const _invalidVitals = <String, double>{
    'BPM': 89.425,
    'SBP': 116.235,
    'DBP': 70.525,
    'SpO2': 97.635,
  };

  bool _matchesInvalidTemplate(HealthVitalsRecord record) {
    bool _compare(dynamic rawValue, double target) {
      if (rawValue is num) {
        return rawValue.toStringAsFixed(3) == target.toStringAsFixed(3);
      }
      if (rawValue is String) {
        final parsed = double.tryParse(rawValue);
        if (parsed == null) {
          return false;
        }
        return parsed.toStringAsFixed(3) == target.toStringAsFixed(3);
      }
      return false;
    }

    final data = record.snapshotData;
    return _compare(data['BPM'], _invalidVitals['BPM']!) &&
        _compare(data['SBP'], _invalidVitals['SBP']!) &&
        _compare(data['DBP'], _invalidVitals['DBP']!) &&
        _compare(data['SpO2'], _invalidVitals['SpO2']!);
  }

  Future<void> _maybeClearInvalidVitals(HealthVitalsRecord? record) async {
    if (record == null || _clearInFlight) {
      return;
    }
    final matchesTemplate = _matchesInvalidTemplate(record);
    if (!matchesTemplate) {
      return;
    }
    _clearInFlight = true;
    try {
      await actions.ensureHealthVitalsLiveDoc(forceReset: true);
    } catch (e) {
      debugPrint('ensureHealthVitalsLiveDoc reset failure: $e');
    } finally {
      _clearInFlight = false;
    }
  }

  void _maybeBroadcastVitals(HealthVitalsRecord? record) {
    if (record == null) {
      return;
    }

    _maybeClearInvalidVitals(record);
    final signature = _buildVitalsSignature(record);
    if (_lastVitalsBroadcastSignature == signature) {
      return;
    }
    _lastVitalsBroadcastSignature = signature;

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.sendVitalsToConnectedDevices(
        bpm: record.hasBpm() ? record.bpm : null,
        sbp: record.hasSbp() ? record.sbp : null,
        dbp: record.hasDbp() ? record.dbp : null,
        spo2: record.hasSpO2() ? record.spO2 : null,
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.globalInternetChecker();
      await actions.initppgbuffers();
      await actions.clearHealthVitalsOnSignup();
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

    final appState = FFAppState();
    final isDeviceConnected = appState.activeBleDevice != null;
    final DateTime? pairedAt = appState.lastBleConnectedAt;
    final String statusText = isDeviceConnected ? 'Connected' : 'Not connected';
    final String detailText = isDeviceConnected
      ? (pairedAt != null
        ? 'Paired at ${dateTimeFormat('jm', pairedAt)}'
        : 'Paired just now')
      : 'Tap to pair device';
    final Color statusColor =
      isDeviceConnected ? const Color(0xFF52D273) : const Color(0xFFE25555);
    final IconData statusIcon =
      isDeviceConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled;

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
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: Container(
                          height: 800.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      30.0, 40.0, 0.0, 0.0),
                                  child: Text(
                                    'Home',
                                    textAlign: TextAlign.start,
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
                                          color: Color(0xFFCECECD),
                                          fontSize: 40.0,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 30.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(PPGTestWidget.routeName);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF0A1218),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 8.0, 8.0, 8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 0.0, 0.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, 0.0),
                                                        child: Icon(
                                                          Icons.favorite,
                                                          color:
                                                              Color(0xFF438FE4),
                                                          size: 50.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Heart Rate',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.roboto(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFFCECECD),
                                                        fontSize: 20.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  child: currentUserReference ==
                                                          null
                                                      ? Container()
                                                      : StreamBuilder<
                                                          List<
                                                              HealthVitalsRecord>>(
                                                          stream:
                                                              queryHealthVitalsRecord(
                                                            parent:
                                                                currentUserReference,
                              queryBuilder: (q) =>
                                q.where(
                                  FieldPath
                                    .documentId,
                                  isEqualTo:
                                    'live',
                                ),
                                                            singleRecord: true,
                                                          ),
                                                          builder: (context,
                                                              snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: SizedBox(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child: SpinKitRing(
                                                              color:
                                                                  Colors.white,
                                                              size: 50.0,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      List<HealthVitalsRecord>
                                                          heartRateHealthVitalsRecordList =
                                                          snapshot.data!;
                                                      // Return an empty Container when the item does not exist.
                                                      if (snapshot
                                                          .data!.isEmpty) {
                                                        return Container();
                                                      }
                                                      final heartRateHealthVitalsRecord =
                                                          heartRateHealthVitalsRecordList
                                                                  .isNotEmpty
                                                              ? heartRateHealthVitalsRecordList
                                                                  .first
                                                              : null;

                            _maybeBroadcastVitals(
                              heartRateHealthVitalsRecord);

                                                      return RichText(
                                                        textScaler:
                                                            MediaQuery.of(
                                                                    context)
                                                                .textScaler,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  valueOrDefault<
                                                                      String>(
                                                                heartRateHealthVitalsRecord
                                                                    ?.bpm
                                                                    .toString(),
                                                                '-',
                                                              ),
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF438FE4),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 30.0,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: ' BPM',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF888B92),
                                                                fontSize: 20.0,
                                                              ),
                                                            )
                                                          ],
                                                          style: TextStyle(),
                                                        ),
                                                      );
                                                          },
                                                        ),
                                                ),
                                              ].divide(SizedBox(height: 5.0)),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 15.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 15.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await actions.createLatestDoc();
                                    context.pushNamed(
                                      PPGTestWidget.routeName,
                                    );
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF0A1218),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5.0, 8.0, 8.0, 8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional(
                                                -1.0, 0.0),
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(10.0, 0.0,
                                                          0.0, 0.0),
                                              child: Column(
                                                mainAxisSize:
                                                    MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, 0.0),
                                                        child: Icon(
                                                          Icons.water_drop,
                                                          color:
                                                              Color(0xFF438FE4),
                                                          size: 50.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize:
                                                  MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Blood Pressure',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .override(
                                                            font:
                                                                GoogleFonts.roboto(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            color:
                                                                Color(0xFFCECECD),
                                                            fontSize: 20.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(),
                                                  child: currentUserReference ==
                                                          null
                                                      ? Container()
                                                      : StreamBuilder<
                                                          List<
                                                              HealthVitalsRecord>>(
                                                          stream:
                                                              queryHealthVitalsRecord(
                                                            parent:
                                                                currentUserReference,
                              queryBuilder: (q) =>
                                q.where(
                                  FieldPath
                                    .documentId,
                                  isEqualTo:
                                    'live',
                                ),
                                                            singleRecord: true,
                                                          ),
                                                          builder: (context,
                                                              snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: SizedBox(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child: SpinKitRing(
                                                              color:
                                                                  Colors.white,
                                                              size: 50.0,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      List<HealthVitalsRecord>
                                                          bpHealthVitalsRecordList =
                                                          snapshot.data!;
                                                      // Return an empty Container when the item does not exist.
                                                      if (snapshot
                                                          .data!.isEmpty) {
                                                        return Container();
                                                      }
                                                      final bpHealthVitalsRecord =
                                                          bpHealthVitalsRecordList
                                                                  .isNotEmpty
                                                              ? bpHealthVitalsRecordList
                                                                  .first
                                                              : null;

                            _maybeBroadcastVitals(
                              bpHealthVitalsRecord);

                                                      return RichText(
                                                        textScaler:
                                                            MediaQuery.of(
                                                                    context)
                                                                .textScaler,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  valueOrDefault<
                                                                      String>(
                                                                bpHealthVitalsRecord
                                                                    ?.sbp
                                                                    .toString(),
                                                                '70',
                                                              ),
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF438FE4),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 30.0,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: '/',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF438FE4),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 30.0,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  valueOrDefault<
                                                                      String>(
                                                                bpHealthVitalsRecord
                                                                    ?.dbp
                                                                    .toString(),
                                                                '-',
                                                              ),
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF438FE4),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 30.0,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: ' mmHg',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF888B92),
                                                                fontSize: 20.0,
                                                              ),
                                                            )
                                                          ],
                                                          style: TextStyle(),
                                                        ),
                                                      );
                                                          },
                                                        ),
                                                ),
                                              ].divide(SizedBox(height: 5.0)),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 15.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 15.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                        TestingPageWidget.routeName);
                                  },
                                  child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.8,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF0A1218),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 8.0, 8.0, 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1.0, 0.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 0.0, 0.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  7.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: RichText(
                                                        textScaler:
                                                            MediaQuery.of(
                                                                    context)
                                                                .textScaler,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'O',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .robotoMono(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: Color(
                                                                        0xFF438FE4),
                                                                    fontSize:
                                                                        39.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            TextSpan(
                                                              text: '2',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 25.0,
                                                              ),
                                                            )
                                                          ],
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .raleway(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: Color(
                                                                    0xFF438FE4),
                                                                fontSize: 39.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Blood Oxygen Saturation',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFFCECECD),
                                                      fontSize: 18.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(),
                                                child: currentUserReference ==
                                                        null
                                                    ? Container()
                                                    : StreamBuilder<
                                                        List<
                                                            HealthVitalsRecord>>(
                                                        stream:
                                                            queryHealthVitalsRecord(
                                                          parent:
                                                              currentUserReference,
                              queryBuilder: (q) =>
                                q.where(
                                FieldPath
                                  .documentId,
                                isEqualTo:
                                  'live',
                                ),
                                                          singleRecord: true,
                                                        ),
                                                        builder: (context,
                                                            snapshot) {
                                                    // Customize what your widget looks like when it's loading.
                                                    if (!snapshot.hasData) {
                                                      return Center(
                                                        child: SizedBox(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          child: SpinKitRing(
                                                            color: Colors.white,
                                                            size: 50.0,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    List<HealthVitalsRecord>
                                                        spo2HealthVitalsRecordList =
                                                        snapshot.data!;
                                                    // Return an empty Container when the item does not exist.
                                                    if (snapshot
                                                        .data!.isEmpty) {
                                                      return Container();
                                                    }
                                                    final spo2HealthVitalsRecord =
                                                        spo2HealthVitalsRecordList
                                                                .isNotEmpty
                                                            ? spo2HealthVitalsRecordList
                                                                .first
                                                            : null;

                            _maybeBroadcastVitals(
                              spo2HealthVitalsRecord);

                                                    return RichText(
                                                      textScaler:
                                                          MediaQuery.of(context)
                                                              .textScaler,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                valueOrDefault<
                                                                    String>(
                                                              spo2HealthVitalsRecord
                                                                  ?.spO2
                                                                  .toString(),
                                                              '-',
                                                            ),
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF438FE4),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 30.0,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: ' %',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF888B92),
                                                              fontSize: 25.0,
                                                            ),
                                                          )
                                                        ],
                                                        style: TextStyle(),
                                                      ),
                                                    );
                                                        },
                                                      ),
                                              ),
                                            ].divide(SizedBox(height: 5.0)),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 15.0)),
                                    ),
                                  ),
                                ),
                              ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 50.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      BluetoothPageWidget.routeName,
                                      queryParameters: {
                                        'isBTEnabled': serializeParam(
                                          false,
                                          ParamType.bool,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF0A1218),
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x66000000),
                                          blurRadius: 12.0,
                                          offset: Offset(0.0, 6.0),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20.0, 16.0, 20.0, 16.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFF438FE4)
                                                  .withValues(alpha: 0.15),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(10.0),
                                            child: Icon(
                                              statusIcon,
                                              color: statusColor,
                                              size: 28.0,
                                            ),
                                          ),
                                          SizedBox(width: 16.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  statusText,
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
                                                            color: statusColor,
                                                            fontSize: 20.0,
                                                            letterSpacing: 0.0,
                                                          ),
                                                ),
                                                SizedBox(height: 4.0),
                                                Text(
                                                  detailText,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFFCECECD),
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color(0xFF8E9199),
                                            size: 28.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!FFAppState().Internet)
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 1.0,
                decoration: BoxDecoration(
                  color: Color(0xFF1B1F24),
                  border: Border.all(
                    color: Color(0xFF03080C),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
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
                            color: Color(0xFFCECECD),
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

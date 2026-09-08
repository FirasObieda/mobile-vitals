import 'dart:math' as math;

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'history_model.dart';
export 'history_model.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  static String routeName = 'History';
  static String routePath = '/history';

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  late HistoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HistoryModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.globalInternetChecker();
      await actions.fetchWeeklyVitalsAverages();
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

    final weeklyLabelsRaw = List<String>.from(FFAppState().weeklyLabels);
    final hrRaw = List<double>.from(FFAppState().weeklyHR);
    final spo2Raw = List<double>.from(FFAppState().weeklySpO2);
    final sbpRaw = List<double>.from(FFAppState().weeklySBP);
    final dbpRaw = List<double>.from(FFAppState().weeklyDBP);

    final lengths = <int>[
      weeklyLabelsRaw.length,
      hrRaw.length,
      spo2Raw.length,
      sbpRaw.length,
      dbpRaw.length,
    ].where((len) => len > 0).toList();

    final dataLength = lengths.isEmpty ? 0 : lengths.reduce(math.min);

    final chartLabels = weeklyLabelsRaw.take(dataLength).toList();
    final hrSeries = hrRaw.take(dataLength).toList();
    final spo2Series = spo2Raw.take(dataLength).toList();
    final sbpSeries = sbpRaw.take(dataLength).toList();
    final dbpSeries = dbpRaw.take(dataLength).toList();
    final xValues =
        List<double>.generate(dataLength, (index) => index.toDouble());

    final combinedValues = <double>[
      ...hrSeries,
      ...spo2Series,
      ...sbpSeries,
      ...dbpSeries,
    ];

    final positiveValues =
        combinedValues.where((value) => value > 0).toList();
    final hasChartData = positiveValues.isNotEmpty;

    double minY;
    double maxY;
    if (hasChartData) {
      final minValue = positiveValues.reduce(math.min);
      final maxValue = positiveValues.reduce(math.max);
      minY = math.max(0.0, minValue - 5);
      maxY = math.max(minY + 10, (maxValue * 1.1).ceilToDouble());
    } else {
      minY = 0.0;
      maxY = 120.0;
    }

    double computeYInterval(double upperBound) {
      if (upperBound <= 100) {
        return 10.0;
      }
      if (upperBound <= 160) {
        return 20.0;
      }
      if (upperBound <= 220) {
        return 25.0;
      }
      return 50.0;
    }

    final yInterval = computeYInterval(maxY);
    final xMax = xValues.isEmpty ? 6.0 : xValues.last;

    final weeklySeries = dataLength == 0
        ? <FFLineChartData>[]
        : [
            FFLineChartData(
              xData: xValues,
              yData: hrSeries,
              settings: LineChartBarData(
                color: Color(0xFFCC7A8C),
                barWidth: 2.5,
                isCurved: true,
                preventCurveOverShooting: true,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
              ),
            ),
            FFLineChartData(
              xData: xValues,
              yData: sbpSeries,
              settings: LineChartBarData(
                color: Color(0xFF3EA981),
                barWidth: 2.5,
                isCurved: true,
                preventCurveOverShooting: true,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
              ),
            ),
            FFLineChartData(
              xData: xValues,
              yData: dbpSeries,
              settings: LineChartBarData(
                color: Color(0xFF88D0B3),
                barWidth: 2.5,
                isCurved: true,
                preventCurveOverShooting: true,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
              ),
            ),
            FFLineChartData(
              xData: xValues,
              yData: spo2Series,
              settings: LineChartBarData(
                color: Color(0xFF7BA1BF),
                barWidth: 2.5,
                isCurved: true,
                preventCurveOverShooting: true,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
              ),
            ),
          ];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF1B1F24),
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
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
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            30.0, 40.0, 0.0, 0.0),
                                        child: Text(
                                          'History',
                                          textAlign: TextAlign.start,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.roboto(
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
                                          0.0, 50.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional(
                                                -1.0, -1.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      20.0, 0.0, 0.0, 0.0),
                                              child: Text(
                                                'Last 7 Days Average',
                                                textAlign: TextAlign.start,
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
                                                      fontSize: 20.0,
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
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 100.0)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 30.0, 0.0, 0.0),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.8,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF0A0E17),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5.0, 8.0, 8.0, 8.0),
                                          child: StreamBuilder<
                                              List<HealthVitalsRecord>>(
                                            stream: queryHealthVitalsRecord(
                                              queryBuilder:
                                                  (healthVitalsRecord) =>
                                                      healthVitalsRecord.where(
                                                'userRef',
                                                isEqualTo: currentUserReference,
                                              ),
                                              singleRecord: true,
                                            ),
                                            builder: (context, snapshot) {
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
                                                  rowHealthVitalsRecordList =
                                                  snapshot.data!;
                                              // Return an empty Container when the item does not exist.
                                              if (snapshot.data!.isEmpty) {
                                                return Container();
                                              }
                                              final rowHealthVitalsRecord =
                                                  rowHealthVitalsRecordList
                                                          .isNotEmpty
                                                      ? rowHealthVitalsRecordList
                                                          .first
                                                      : null;

                                              return Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(),
                                                        ),
                                                        Text(
                                                          valueOrDefault<
                                                              String>(
                                                            rowHealthVitalsRecord
                                                                        ?.hasBpm() ==
                                                                    true
                                                                ? rowHealthVitalsRecord!
                                                                    .bpm
                                                                    .toString()
                                                                : null,
                                                            '-',
                                                          ).maybeHandleOverflow(
                                                            maxChars: 30,
                                                            replacement: '…',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .roboto(
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
                                                                    0xFFCECECD),
                                                                fontSize: 25.0,
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
                                                        Text(
                                                          'BPM',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .roboto(
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
                                                                    0xFF969BA1),
                                                                fontSize: 16.0,
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
                                                      ].divide(SizedBox(
                                                          height: 5.0)),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                rowHealthVitalsRecord
                                                                            ?.hasSbp() ==
                                                                        true
                                                                    ? rowHealthVitalsRecord!
                                                                        .sbp
                                                                        .toString()
                                                                    : null,
                                                                '-',
                                                              ).maybeHandleOverflow(
                                                                maxChars: 30,
                                                                replacement:
                                                                    '…',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .roboto(
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
                                                                        0xFFCECECD),
                                                                    fontSize:
                                                                        25.0,
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
                                                            Text(
                                                              '/',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .roboto(
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
                                                                        0xFFCECECD),
                                                                    fontSize:
                                                                        25.0,
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
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                rowHealthVitalsRecord
                                                                            ?.hasDbp() ==
                                                                        true
                                                                    ? rowHealthVitalsRecord!
                                                                        .dbp
                                                                        .toString()
                                                                    : null,
                                                                '-',
                                                              ).maybeHandleOverflow(
                                                                maxChars: 30,
                                                                replacement:
                                                                    '…',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .roboto(
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
                                                                        0xFFCECECD),
                                                                    fontSize:
                                                                        25.0,
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
                                                          ],
                                                        ),
                                                        Text(
                                                          'mmHg',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .roboto(
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
                                                                    0xFF969BA1),
                                                                fontSize: 16.0,
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
                                                      ].divide(SizedBox(
                                                          height: 5.0)),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(),
                                                        ),
                                                        Text(
                                                          valueOrDefault<
                                                              String>(
                                                            rowHealthVitalsRecord
                                                                        ?.hasSpO2() ==
                                                                    true
                                                                ? rowHealthVitalsRecord!
                                                                    .spO2
                                                                    .toString()
                                                                : null,
                                                            '-',
                                                          ).maybeHandleOverflow(
                                                            maxChars: 30,
                                                            replacement: '…',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .roboto(
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
                                                                    0xFFCECECD),
                                                                fontSize: 25.0,
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
                                                        Text(
                                                          '%',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .roboto(
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
                                                                    0xFF969BA1),
                                                                fontSize: 16.0,
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
                                                      ].divide(SizedBox(
                                                          height: 5.0)),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 15.0)),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 24.0, 0.0, 0.0),
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.85,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF0A0E17),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: Color(0xFF0A0E17),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              SizedBox(
                                                height: 260.0,
                                                child: weeklySeries.isNotEmpty &&
                                                        hasChartData
                                                    ? FlutterFlowLineChart(
                                                        data: weeklySeries,
                                                        chartStylingInfo:
                                                            ChartStylingInfo(
                                                          enableTooltip: true,
                                                          tooltipBackgroundColor:
                                                              Color(0xFF2B3139),
                                                          backgroundColor:
                                                              Colors.transparent,
                                                          showBorder: false,
                                                          showGrid: true,
                                                          borderColor:
                                                              Colors.transparent,
                                                        ),
                                                        axisBounds: AxisBounds(
                                                          minX: 0.0,
                                                          maxX: xMax,
                                                          minY: minY,
                                                          maxY: maxY,
                                                        ),
                                                        xAxisLabelInfo:
                                                            AxisLabelInfo(
                                                          title: 'Last 7 Days',
                                                          titleTextStyle:
                                                              TextStyle(
                                                            color:
                                                                Color(0xFF7BA1BF),
                                                            fontSize: 12.0,
                                                          ),
                                                          showLabels: true,
                                                          labelTextStyle:
                                                              TextStyle(
                                                            color:
                                                                Color(0xFF969BA1),
                                                            fontSize: 11.0,
                                                          ),
                                                          labelInterval: 1.0,
                                                          labelFormatter:
                                                              LabelFormatter(
                                                            numberFormat:
                                                                (value) {
                                                              final idx =
                                                                  value.round();
                                                              if (idx < 0 ||
                                                                  idx >=
                                                                      chartLabels
                                                                          .length) {
                                                                return '';
                                                              }
                                                              final raw =
                                                                  chartLabels[
                                                                      idx];
                                                              final parsed =
                                                                  DateTime.tryParse(
                                                                      raw);
                                                              if (parsed !=
                                                                  null) {
                                                                return DateFormat(
                                                                        'E')
                                                                    .format(
                                                                        parsed);
                                                              }
                                                              return raw;
                                                            },
                                                          ),
                                                          reservedSize: 42.0,
                                                        ),
                                                        yAxisLabelInfo:
                                                            AxisLabelInfo(
                                                          title:
                                                              'Average Value',
                                                          titleTextStyle:
                                                              TextStyle(
                                                            color:
                                                                Color(0xFF7BA1BF),
                                                            fontSize: 12.0,
                                                          ),
                                                          showLabels: true,
                                                          labelTextStyle:
                                                              TextStyle(
                                                            color:
                                                                Color(0xFF969BA1),
                                                            fontSize: 11.0,
                                                          ),
                                                          labelInterval:
                                                              yInterval,
                                                          labelFormatter:
                                                              LabelFormatter(
                                                            numberFormat:
                                                                (value) => value
                                                                    .toStringAsFixed(
                                                                        0),
                                                          ),
                                                          reservedSize: 46.0,
                                                        ),
                                                      )
                                                    : Center(
                                                        child: Text(
                                                          'No vitals recorded for the past week.',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .roboto(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                    ),
                                                                    color: Color(
                                                                        0xFF969BA1),
                                                                    fontSize:
                                                                        14.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                  ),
                                                        ),
                                                      ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(0.0, 12.0,
                                                            0.0, 0.0),
                                                child:
                                                    FlutterFlowChartLegendWidget(
                                                  entries: const [
                                                    LegendEntry(
                                                        Color(0xFFCC7A8C),
                                                        'HR (BPM)'),
                                                    LegendEntry(
                                                        Color(0xFF3EA981),
                                                        'SBP (mmHg)'),
                                                    LegendEntry(
                                                        Color(0xFF88D0B3),
                                                        'DBP (mmHg)'),
                                                    LegendEntry(
                                                        Color(0xFF7BA1BF),
                                                        'SpO2 (%)'),
                                                  ],
                                                  textStyle: TextStyle(
                                                    color: Color(0xFFCECECD),
                                                    fontSize: 12.0,
                                                  ),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  borderColor:
                                                      Colors.transparent,
                                                  indicatorSize: 10.0,
                                                  textPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(8.0, 0.0,
                                                              0.0, 0.0),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(0.0, 16.0,
                                                            0.0, 0.0),
                                                // Temporary helper to populate sample vitals while integrating the chart.
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await actions
                                                        .generateDummyWeeklyVitals();
                                                  },
                                                  text:
                                                      'Generate Dummy Data',
                                                  options: FFButtonOptions(
                                                    height: 44.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(24.0,
                                                                0.0, 24.0, 0.0),
                                                    color:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    textStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .roboto(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontStyle,
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                    elevation: 0.0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  showLoadingIndicator: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  1.0, 0.0, 0.0, 0.0),
                                          child: Container(
                                            width: 175.0,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF0A0E17),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: Color(0xFF0A0E17),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Icon(
                                                          Icons.circle,
                                                          color:
                                                              Color(0xFFCC7A8C),
                                                          size: 15.0,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            'Heart Rate',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .roboto(
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
                                                                      0xFFCECECD),
                                                                  fontSize:
                                                                      10.0,
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
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        color:
                                                            Color(0xFF3BAA7C),
                                                        size: 15.0,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            'Blood Pressure',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .roboto(
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
                                                                      0xFFCECECD),
                                                                  fontSize:
                                                                      10.0,
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
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Icon(
                                                          Icons.circle,
                                                          color:
                                                              Color(0xFF77A1C2),
                                                          size: 15.0,
                                                        ),
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Blood Oxygen',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .roboto(
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
                                                                        0xFFCECECD),
                                                                    fontSize:
                                                                        10.0,
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
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Container(
                                            width: 133.0,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF0A0E17),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              border: Border.all(
                                                color: Color(0xFF0A0E17),
                                              ),
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Text(
                                                'Show More',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.roboto(
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
                                                      color: Color(0xFFCECECD),
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
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ].divide(SizedBox(height: 10.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 10.0)),
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
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
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
          ],
        ),
      ),
    );
  }
}

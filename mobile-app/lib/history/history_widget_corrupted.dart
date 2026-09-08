/*
import 'dart:math' as math;

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
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
                                ?.bPMAverage
                                .toString(),
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
                                  ?.sBPAverage
                                  .toString(),
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
                                  ?.dBPAverage
                                  .toString(),
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
                                ?.spO2Average
                                .toString(),
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
                                        width: contentWidth,
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
*/

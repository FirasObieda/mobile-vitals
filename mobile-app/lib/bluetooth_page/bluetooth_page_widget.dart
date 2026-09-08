import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/empty_devices_widget.dart';
import '/components/strength_indicator_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bluetooth_page_model.dart';
export 'bluetooth_page_model.dart';

class BluetoothPageWidget extends StatefulWidget {
  const BluetoothPageWidget({
    super.key,
    bool? isBTEnabled,
  }) : this.isBTEnabled = isBTEnabled ?? false;

  final bool isBTEnabled;

  static String routeName = 'BluetoothPage';
  static String routePath = '/bluetoothPage';

  @override
  State<BluetoothPageWidget> createState() => _BluetoothPageWidgetState();
}

class _BluetoothPageWidgetState extends State<BluetoothPageWidget>
    with TickerProviderStateMixin {
  late BluetoothPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BluetoothPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isBluetoothEnabled = widget.isBTEnabled;
      safeSetState(() {});
      if (_model.isBluetoothEnabled) {
        _model.isFetchingConnectedDevices = true;
        _model.isFetchingDevices = true;
        safeSetState(() {});
        _model.fetchedConnectedDevices = await actions.getConnectedDevices();
        _model.isFetchingConnectedDevices = false;
        _model.connectedDevices =
            _model.fetchedConnectedDevices!.toList().cast<BTDeviceStruct>();
        safeSetState(() {});
        _model.fetchedDevices = await actions.findDevices();
        _model.isFetchingDevices = false;
        _model.foundDevices =
            _model.fetchedDevices!.toList().cast<BTDeviceStruct>();
        safeSetState(() {});
      }
    });

    animationsMap.addAll({
      'textOnPageLoadAnimation1': AnimationInfo(
        loop: true,
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 1000.0.ms,
            begin: 0.5,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        loop: true,
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 1000.0.ms,
            begin: 0.5,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF1B1F24),
        appBar: AppBar(
          backgroundColor: Color(0xFF070C10),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 55.0,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFFCECECD),
              size: 25.0,
            ),
            onPressed: () async {
              context.pushNamed(HomeWidget.routeName);
            },
          ),
          title: Text(
            'Bluetooth Devices',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.roboto(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: Color(0xFFCECECD),
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 10.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!widget.isBTEnabled)
                      Expanded(
                        child: Text(
                          'Turn on Bluetooth to scan and connect to nearby devices.',
                          style: GoogleFonts.roboto(
                            color: Color(0xFFCECECD),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    FlutterFlowIconButton(
                      borderColor: Colors.white,
                      borderRadius: 20.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: Color(0xFFCECECD),
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.goNamed(SplashPageWidget.routeName);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: [
                      if (_model.isBluetoothEnabled)
                        Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SingleChildScrollView(
                                    primary: false,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 10.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Connected Devices',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFFCECECD),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              if (_model
                                                      .isFetchingConnectedDevices ??
                                                  true)
                                                Text(
                                                  'Finding...',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        font: GoogleFonts.inter(
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
                                                        color:
                                                            Color(0xFFCECECD),
                                                        letterSpacing: 0.0,
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
                                                ).animateOnPageLoad(animationsMap[
                                                    'textOnPageLoadAnimation1']!),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 16.0, 0.0, 0.0),
                                          child: Builder(
                                            builder: (context) {
                                              final displayConnectedDevcies =
                                                  _model.connectedDevices
                                                      .toList();
                                              if (displayConnectedDevcies
                                                  .isEmpty) {
                                                return Center(
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 50.0,
                                                    child: EmptyDevicesWidget(
                                                      text: '',
                                                    ),
                                                  ),
                                                );
                                              }

                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    displayConnectedDevcies
                                                        .length,
                                                itemBuilder: (context,
                                                    displayConnectedDevciesIndex) {
                                                  final displayConnectedDevciesItem =
                                                      displayConnectedDevcies[
                                                          displayConnectedDevciesIndex];
                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 12.0),
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        context.pushNamed(
                                                          DevicePageWidget
                                                              .routeName,
                                                          queryParameters: {
                                                            'deviceName':
                                                                serializeParam(
                                                              '',
                                                              ParamType.String,
                                                            ),
                                                            'deviceId':
                                                                serializeParam(
                                                              '',
                                                              ParamType.String,
                                                            ),
                                                            'deviceRssi':
                                                                serializeParam(
                                                              0,
                                                              ParamType.int,
                                                            ),
                                                            'hasWriteCharacteristic':
                                                                serializeParam(
                                                              false,
                                                              ParamType.bool,
                                                            ),
                                                          }.withoutNulls,
                                                        );
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFF0A1218),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          border: Border.all(
                                                            color: Color(
                                                                0xFF02050A),
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      16.0,
                                                                      12.0,
                                                                      16.0,
                                                                      12.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          displayConnectedDevciesItem
                                                                              .name,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                                color: Color(0xFFCECECD),
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            StrengthIndicatorWidget(
                                                                          key: Key(
                                                                              'Keyejx_${displayConnectedDevciesIndex}_of_${displayConnectedDevcies.length}'),
                                                                          rssi:
                                                                              displayConnectedDevciesItem.rssi,
                                                                          color:
                                                                              valueOrDefault<Color>(
                                                                            () {
                                                                              if (displayConnectedDevciesItem.rssi >= -67) {
                                                                                return Color(0xFF249689);
                                                                              } else if (displayConnectedDevciesItem.rssi >= -90) {
                                                                                return Color(0xFFF9CF58);
                                                                              } else {
                                                                                return Color(0xFFFF5963);
                                                                              }
                                                                            }(),
                                                                            Color(0xFF249689),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            5.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      displayConnectedDevciesItem
                                                                          .id,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.inter(
                                                                              fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Color(0xFFCECECD),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                color: Colors
                                                                    .white,
                                                                size: 24.0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 50.0),
                                    child: SingleChildScrollView(
                                      primary: false,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 10.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Devices',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              Color(0xFFCECECD),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                                if (!_model.isFetchingDevices)
                                                  InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      _model.isFetchingConnectedDevices =
                                                          true;
                                                      _model.isFetchingDevices =
                                                          true;
                                                      safeSetState(() {});
                                                      _model.fetchedConnectedDevicesCopy =
                                                          await actions
                                                              .getConnectedDevices();
                                                      _model.isFetchingConnectedDevices =
                                                          false;
                                                      _model.connectedDevices = _model
                                                          .fetchedConnectedDevices!
                                                          .toList()
                                                          .cast<
                                                              BTDeviceStruct>();
                                                      safeSetState(() {});
                                                      _model.fetchedDevicesCopy =
                                                          await actions
                                                              .findDevices();
                                                      _model.isFetchingDevices =
                                                          false;
                                                      _model.foundDevices = _model
                                                          .fetchedDevices!
                                                          .toList()
                                                          .cast<
                                                              BTDeviceStruct>();
                                                      safeSetState(() {});

                                                      safeSetState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.refresh_rounded,
                                                      color: Color(0xFFCECECD),
                                                      size: 22.0,
                                                    ),
                                                  ),
                                                if (_model.isFetchingDevices)
                                                  Text(
                                                    'Scanning...',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
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
                                                          color:
                                                              Color(0xFFCECECD),
                                                          letterSpacing: 0.0,
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
                                                  ).animateOnPageLoad(animationsMap[
                                                      'textOnPageLoadAnimation2']!),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 16.0, 0.0, 0.0),
                                            child: Builder(
                                              builder: (context) {
                                                final displayDevices = _model
                                                    .foundDevices
                                                    .toList();
                                                if (displayDevices.isEmpty) {
                                                  return Center(
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 50.0,
                                                      child: EmptyDevicesWidget(
                                                        text: '',
                                                      ),
                                                    ),
                                                  );
                                                }

                                                return ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      displayDevices.length,
                                                  itemBuilder: (context,
                                                      displayDevicesIndex) {
                                                    final displayDevicesItem =
                                                        displayDevices[
                                                            displayDevicesIndex];
                                                    return Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  12.0),
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                              _model.hasWrite =
                                await actions
                                  .connectDevice(
                              displayDevicesItem,
                              );
                              await actions
                                .initppgbuffers();
                              await actions
                                  .startBleReceiveLoop(
                                      displayDevicesItem);
                                                          _model.addToConnectedDevices(
                                                              displayDevicesItem);
                                                          safeSetState(() {});

                                                          context.pushNamed(
                                                            DevicePageWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'deviceName':
                                                                  serializeParam(
                                                                displayDevicesItem
                                                                    .name,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'deviceId':
                                                                  serializeParam(
                                                                displayDevicesItem
                                                                    .id,
                                                                ParamType
                                                                    .String,
                                                              ),
                                                              'deviceRssi':
                                                                  serializeParam(
                                                                displayDevicesItem
                                                                    .rssi,
                                                                ParamType.int,
                                                              ),
                                                              'hasWriteCharacteristic':
                                                                  serializeParam(
                                                                _model.hasWrite,
                                                                ParamType.bool,
                                                              ),
                                                            }.withoutNulls,
                                                          );

                                                          safeSetState(() {});
                                                        },
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFF0A1218),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xFF02050A),
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        12.0,
                                                                        16.0,
                                                                        12.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              8.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            displayDevicesItem.name,
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  font: GoogleFonts.inter(
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                  ),
                                                                                  color: Color(0xFFCECECD),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              StrengthIndicatorWidget(
                                                                            key:
                                                                                Key('Keyswa_${displayDevicesIndex}_of_${displayDevices.length}'),
                                                                            rssi:
                                                                                displayDevicesItem.rssi,
                                                                            color:
                                                                                valueOrDefault<Color>(
                                                                              () {
                                                                                if (displayDevicesItem.rssi >= -67) {
                                                                                  return Color(0xFF249689);
                                                                                } else if (displayDevicesItem.rssi >= -90) {
                                                                                  return Color(0xFFF9CF58);
                                                                                } else {
                                                                                  return Color(0x00000000);
                                                                                }
                                                                              }(),
                                                                              Color(0xFF249689),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          5.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Text(
                                                                        displayDevicesItem
                                                                            .id,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .labelSmall
                                                                            .override(
                                                                              font: GoogleFonts.inter(
                                                                                fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                              ),
                                                                              color: Color(0xFFCECECD),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_rounded,
                                                                  color: Color(
                                                                      0xFFCECECD),
                                                                  size: 24.0,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (!_model.isBluetoothEnabled)
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'Turn on bluetooth to connect to the health tracker.',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: const Color(0xFFCECECD),
                  letterSpacing: 0.0,
                  fontSize: 18.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

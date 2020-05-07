import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPip {
  static const String CHANNEL_NAME = 'flutter_pip';
  static const String SET_PIP_READY = 'setPiPReady';
  static const String SET_PIP_READY_ARG_NUMERATOR = 'numerator';
  static const String SET_PIP_READY_ARG_DENOMINATOR = 'denominator';
  static const String UNSET_PIP_READY = 'unsetPiPReady';
  static const String GET_PIP_READY = 'getPiPReadyStatus';
  static const String SWITCH_TO_PIP_MODE = 'switchToPiPMode';
  static const MethodChannel _channel = const MethodChannel(CHANNEL_NAME);

  static Future<bool> setPipReady(double numerator, double denominator) async {
    return await _channel.invokeMethod(
      SET_PIP_READY,
      {
        SET_PIP_READY_ARG_NUMERATOR: numerator,
        SET_PIP_READY_ARG_DENOMINATOR: denominator,
      },
    );
  }

  static Future<bool> unsetPipReady() async {
    return await _channel.invokeMethod(UNSET_PIP_READY);
  }

  static Future<bool> getPipReady() async {
    return await _channel.invokeMethod(GET_PIP_READY);
  }

  static Future<void> switchToPiPMode() async {
    await _channel.invokeMethod(SWITCH_TO_PIP_MODE);
  }
}

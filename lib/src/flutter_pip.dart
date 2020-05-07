import 'package:flutter/services.dart';

class FlutterPip {
  static const String _CHANNEL_NAME = 'flutter_pip';
  static const String _EVENT_CHANNEL_NAME = 'flutter_pip_event';
  static const String _SET_PIP_READY = 'setPiPReady';
  static const String _SET_PIP_READY_ARG_NUMERATOR = 'numerator';
  static const String _SET_PIP_READY_ARG_DENOMINATOR = 'denominator';
  static const String _UNSET_PIP_READY = 'unsetPiPReady';
  static const String _GET_PIP_READY = 'getPiPReadyStatus';
  static const String _SWITCH_TO_PIP_MODE = 'switchToPiPMode';
  static const MethodChannel _channel = const MethodChannel(_CHANNEL_NAME);
  static const EventChannel _eventChannel =
  const EventChannel(_EVENT_CHANNEL_NAME);

  static Future<bool> setPipReady(double numerator, double denominator) async {
    // TODO: rethrow PlatformExceptions as Custom Exceptions
    return await _channel.invokeMethod(
      _SET_PIP_READY,
      {
        _SET_PIP_READY_ARG_NUMERATOR: numerator,
        _SET_PIP_READY_ARG_DENOMINATOR: denominator,
      },
    );
  }

  static Future<bool> unsetPipReady() async {
    // TODO: rethrow PlatformExceptions as Custom Exceptions
    return await _channel.invokeMethod(_UNSET_PIP_READY);
  }

  static Future<bool> getPipReady() async {
    // TODO: rethrow PlatformExceptions as Custom Exceptions
    return await _channel.invokeMethod(_GET_PIP_READY);
  }

  static Future<void> switchToPiPMode() async {
    // TODO: rethrow PlatformExceptions as Custom Exceptions
    await _channel.invokeMethod(_SWITCH_TO_PIP_MODE);
  }

  // TODO: onPiPModeChanged always triggered because we hook it up in onResume and onPause
  // later I wish there is a way to override activity callbacks especially "onPictureInPictureModeChanged()"
  // callback to prevent sending redundant events.
  static Stream<bool> get onPiPModeChanged => _eventChannel
      .receiveBroadcastStream()
      .map((event) => event as bool)
      .distinct();
}

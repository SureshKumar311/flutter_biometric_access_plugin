import 'dart:convert';

import 'package:biometric_access/utils/biometric_access_utils.dart';
import 'package:flutter/services.dart';

class BiometricAccessPluginException extends PlatformException {
  BiometricAccessPluginException(
      {required super.code, super.message, super.details, super.stacktrace});

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() =>
      {"code": code, "message": message ?? "", "details": details ?? ""};
}

class RDClientNotFound extends BiometricAccessPluginException {
  RDClientNotFound({required super.code, super.message, super.details});
}

class RDException extends BiometricAccessPluginException {
  RDException({required super.code, super.message, super.details});
}

PlatformException erroToRDException(String errorCode, {String? erroMessage}) {
  String message = "";
  switch (errorCode) {
    case "ClientNotFound":
    case "-1509":
      message = "System is still checking status";
      return RDClientNotFound(code: errorCode, message: message);
    case "720":
      message = "Device not ready";
    case "730":
      message = "Capture failed";
    case "710":
    case "-6":
      message = "Device Being used by another application";
    case "740":
      message = "Device needs to be re-initialized";
    case "780":
      message = "The app is out of date. Kindly update your app";
    case "790":
      message =
          "The handset failed for root check. RDService will not be work on this handset";
    case "800":
      message = "Root checking failed";
    case "810":
      message = "RDService is checking root status of your device";
    case "-1307":
      message = "No device connected";
    case "-1142":
      message = "Unknown Sensor";
    case "-1135":
      message = "Invalid template or unsupported template format";
    case "700":
    case "1140":
      message = "Capture Timeout";
    case "-1329":
      message = "Encryption of data failed";
    case "-1524":
      message = "Invalid value for env";
    default:
      message = "Something Went Wrong";
  }

  var rdException = RDException(code: errorCode, message: erroMessage ?? message);
  pluginDebug(rdException);
  return rdException;
}

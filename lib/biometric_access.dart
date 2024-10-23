import 'dart:convert';

import 'package:biometric_access/model/biometric_access_exception.dart';
import 'package:biometric_access/model/device_info_model.dart';
import 'package:biometric_access/model/pid_data_model.dart';
import 'package:biometric_access/model/rd_services_model.dart';
import 'package:biometric_access/utils/biometric_access_enums.dart';
import 'package:biometric_access/utils/biometric_access_utils.dart';

import 'biometric_access_platform_interface.dart';

class BiometricAccess {
  static final BiometricAccess instance = BiometricAccess._internal();
  BiometricAccess._internal();
  factory BiometricAccess() {
    return instance;
  }

  Future<String?> getPlatformVersion() {
    return BiometricAccessPlatform.instance.getPlatformVersion();
  }

  ///get Current state RDService with [rdService]
  RdServiceModel? get rdService => _rdService;
  RdServiceModel? _rdService;

  ///Use [setRDService] Setter to update Current RDService
  set setRDService(RdServiceModel? value) => _rdService = value;

  void get rdServiceChecker {
    if (rdService == null) {
      throw RDException(
          code: "RDService_check_fail",
          message:
              "RDService can't be null. Use discoverAVDM function to scan, or use setRDService Setter");
    }
  }

  ///* Supports Only Web platform
  ///* The first index of RDServices with [RDStatus]==[RDStatus.READY] will be set to [rdService] if it's null
  ///throw [RDClientNotFound] execption if no RDService found
  Future<List<RdServiceModel>> discoverRDServices() async {
    List<RdServiceModel> data = await BiometricAccessPlatform.instance.discoverRDServices();
    if (rdService == null && data.isNotEmpty) {
      setRDService = data.firstWhere(
        (x) => x.rdStatus == RDStatus.READY,
        orElse: () => data.first,
      );
    }
    if (data.isEmpty) throw erroToRDException("ClientNotFound");
    return data;
  }

  /// Returns Raw deviceInfo XML with out Validation
  Future<String?> getDeviceInfoAsXML() async {
    rdServiceChecker;
    return await BiometricAccessPlatform.instance
        .getDeviceInfo(port: rdService!.port, path: rdService?.deviceInfoPath);
  }

  ///* Returns DeviceInfo as ([String],[DeviceInfoModel])
  /// * Use $1=String? and $2=DeviceInfoModel? to access objects [https://dart.dev/language/records#multiple-returns]
  ///* thorw [RDException] when DeviceInfo response fails the validation
  Future<(String, DeviceInfoModel)> getDeviceInfoAsObject() async {
    try {
      rdServiceChecker;
      String? xmlString = await getDeviceInfoAsXML();
      DeviceInfoModel pidData = DeviceInfoModel.fromMap(
          jsonDecode(xmlStrToJsonStr(xmlString ?? ""))["DeviceInfo"]);
      if (xmlString==null||pidData.dpId == null ||
          pidData.dpId == "" ||
          pidData.mi == null ||
          pidData.mi == "" ||
          pidData.additionalInfo?.param == null ||
          (pidData.additionalInfo?.param?.isEmpty ?? true)) {
        throw RDException(
            code: "720",
            message: "Device not ready or No device connected or Invalid Response");
      } else {
        return (xmlString, pidData);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Returns Raw capture XML with out Validation
  Future<String?> captureFingerPrintAsXml(String pidOptions) async {
    rdServiceChecker;
    String? result = await BiometricAccessPlatform.instance.captureFingerPrint(
      pidOptions,
      port: rdService?.port,
      path: rdService?.capturePath,
    );

    return result;
    // if (result != null && result.isNotEmpty) {
    //   final xmlDocument = XmlDocument.parse(result);
    //   XmlElement? errorField = xmlDocument
    //       .findElements("PidData")
    //       .firstOrNull
    //       ?.findElements("Resp")
    //       .firstOrNull;
    //   if (errorField != null) {
    //     String? errorCode = errorField.attributes
    //         .firstWhere((element) => element.name.toString() == "errCode")
    //         .value;
    //     String? errorInfo = errorField.attributes
    //         .firstWhere((element) => element.name.toString() == "errInfo")
    //         .value;
    //     if (errorCode == "0") {
    //       return result;
    //     } else {
    //       throw erroToRDException(errorCode, erroInfo: errorInfo);
    //     }
    //   } else {
    //     throw erroToRDException("");
    //   }
    // } else {
    //   throw erroToRDException("Empty Response");
    // }
  }

  /// * Returns capture Response as ([String],[PidDataModel])
  /// * Use $1=String? and $2=PidDataModel? to access objects [https://dart.dev/language/records#multiple-returns]
  /// * thorw [RDException] when capture response fails the validation
  Future<(String, PidDataModel)> captureFingerPrintAsObject(String pidOptions) async {
    try {
      rdServiceChecker;
      String? result = await captureFingerPrintAsXml(pidOptions);
      PidDataModel data = PidDataModel.fromJson(xmlStrToJsonStr(result ?? "{}"));

      if (result!=null&&data.pidData != null &&
          data.pidData?.data != null &&
          data.pidData?.resp?.errCode == "0" &&
          data.pidData?.hmac != null &&
          data.pidData?.skey != null) {
        return (result, data);
      } else {
        throw erroToRDException(data.pidData?.resp?.errCode ?? "",
            erroMessage: data.pidData?.resp?.errInfo);
      }
    } catch (e) {
      rethrow;
    }
  }
}

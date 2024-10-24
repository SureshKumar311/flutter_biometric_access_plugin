// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';

import 'package:biometric_access/model/rd_services_model.dart';
import 'package:biometric_access/utils/biometric_access_enums.dart';
import 'package:biometric_access/utils/biometric_access_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:universal_io/io.dart';
import 'package:web/web.dart' as web;

import 'biometric_access_platform_interface.dart';

/// A web implementation of the BiometricAccessPlatform of the BiometricAccess plugin.
class BiometricAccessWeb extends BiometricAccessPlatform {
  /// Constructs a BiometricAccessWeb
  BiometricAccessWeb(this.httpClient) {
    //  discoverAVDM();
  }
  final HttpClient httpClient;

  static void registerWith(Registrar registrar) {
    registrar.registerMessageHandler();
    BiometricAccessPlatform.instance = BiometricAccessWeb(HttpClient());
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }

  BioMetricDevice currentAVDM = BioMetricDevice.mantra;

  @override
  Future<List<RdServiceModel>> discoverRDServices() async {
    List<RdServiceModel> avdmList = [];
    //Scan port from 11100 to 11120
    pluginDebug("\nScanning AVDM from port 11100 to 11120, this will take few Seconds",
        usePrint: true);
    for (var i = 11100; i <= 11120; i++) {
      final client =
          await httpClient.openUrl("RDSERVICE", Uri.parse("http://127.0.0.1:$i"));
      client.headers.set("Content-Type", "text/xml; charset=utf-8");
      client.headers.set("Accept", "text/xml");
      try {
        String dataStr =
            xmlStrToJsonStr(await (await client.close()).transform(utf8.decoder).join());
        RdServiceModel rd = RdServiceModel.fromMap(json.decode(dataStr), port: i);
        if (kDebugMode && (rd.rdStatus != null || rd.rdInfo != null)) {
          pluginDebug("Status =>${rd.rdStatus.toString()} Info => ${rd.rdInfo ?? ""}");
        }
        avdmList.add(rd);
      } catch (e) {
        pluginDebug(
          "--- Error on discoverAVDM ---port:$i",
        );
      }
    }

    return avdmList;
  }

  @override
  Future<String> getDeviceInfo({int? port, String? path}) async {
    assert(port != null);
    assert(path != null);
    try {
      final client =
          await httpClient.openUrl("DEVICEINFO", Uri.parse("http://127.0.0.1:$port$path"));
      client.headers.set("Content-Type", "text/xml; charset=utf-8");
      client.headers.set("Accept", "text/xml");
      pluginDebug("Requesting device info at 127.0.0.1:$port$path");
      var data = await (await client.close()).transform(utf8.decoder).join();
      return data;
    } catch (e) {
      pluginDebug("--- Error on getDeviceInfo ---", e: e);
      rethrow;
    }
  }

  @override
  Future<String> captureFingerPrint(String pidOptions, {int? port, String? path}) async {
    assert(port != null);
    assert(path != null);

    try {
      final client =
          await httpClient.openUrl("CAPTURE", Uri.parse("http://127.0.0.1:$port$path"));
      client.headers.set("Content-Type", "text/xml; charset=utf-8");
      client.headers.set("Accept", "text/xml");
      client.write(pidOptions);
      pluginDebug("Requesting Capture at 127.0.0.1:$port$path");
      return await (await client.close()).transform(utf8.decoder).join();
    } catch (e) {
      pluginDebug("--- Error on captureFingerPrint ---", e: e);
      rethrow;
    }
  }
}

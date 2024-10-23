import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:xml2json/xml2json.dart';

pluginDebug(message,
    {StackTrace? s,
    Object? e,
    String name = "Biometric_access Plugin log",
    bool usePrint = false}) {
  if (usePrint) {
    debugPrint("[$name] => $message ${e != null ? "[Error] =>$e" : ""}");
  } else {
    log("$message", stackTrace: s, error: e, name: name);
  }
}

String xmlStrToJsonStr(String xml) {
  final Xml2Json xml2json = Xml2Json()..parse(xml);
  return xml2json.toGData().replaceAll("\$t", "value");
}

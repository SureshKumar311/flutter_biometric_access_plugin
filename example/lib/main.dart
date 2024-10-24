import 'dart:developer';

import 'package:biometric_access/biometric_access.dart';
import 'package:biometric_access/model/biometric_access_exception.dart';
import 'package:biometric_access/model/pid_data_model.dart';
import 'package:biometric_access/model/rd_services_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _biometricAccessPlugin = BiometricAccess();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  bool enableClipBoardCoping = true;
  String? resultData;
  bool showLoader = false;
  List<RdServiceModel>? rdServiceList;
  Size get responsive => MediaQuery.of(context).size;
  TextEditingController textCtrl = TextEditingController(
      text:
          """<?xml version="1.0"?> <PidOptions ver="1.0"> <Opts fCount="1" fType="0" iCount="0" pCount="0" format="0" pidVer="2.0" timeout="10000" posh="UNKNOWN" env="PP" />  </PidOptions>""");

  updateUi() => setState(() {});
  void customToast(String message) {
    debugPrint(message);
    _messangerKey.currentState!.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: const TextStyle(fontSize: 12),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(221, 17, 16, 16),
          title: const Text(
            'BioMetric access',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Container(
              padding: const EdgeInsets.only(right: 15),
              height: 30,
              child: Row(
                children: [
                  const Text(
                    "Auto Clipboard",
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                      value: enableClipBoardCoping,
                      activeColor: Colors.white,
                      onChanged: (bool value) {
                        setState(() {
                          enableClipBoardCoping = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
          child: Wrap(
            children: [
              customButton("Discover RDService", () async {
                setState(() => showLoader = true);
                try {
                   _biometricAccessPlugin.setRDService=null;
                  rdServiceList = (await _biometricAccessPlugin.discoverRDServices());
                  setState(() {});
                  showLoader = false;
                } on RDClientNotFound catch (err)  {
                  debugPrint(err.toJson().toString());
                } 
                catch (e) {
                  customToast(e.toString());
                }
              }),
              customButton("DeviceInfo as XML", () async {
                try {
                  setState(() => showLoader = true);
                  final data = await _biometricAccessPlugin.getDeviceInfoAsXML();
                  resultData = data;
                  await copyToClipboard(resultData);
                } catch (e) {
                  customToast(e.toString());
                }
                setState(() => showLoader = false);
              }),
              customButton("DeviceInfo as object", () async {
                try {
                  setState(() => showLoader = true);
                  final data = await _biometricAccessPlugin.getDeviceInfoAsObject();
                  resultData = (data.$2.toJson().toString());
                  await copyToClipboard(resultData);
                } catch (e) {
                  customToast(e.toString());
                }
                setState(() => showLoader = false);
              }),
              customButton("Capture FingerPrint as object", () async {
                try {
                  setState(() => showLoader = true);
                  (String, PidDataModel) data = await _biometricAccessPlugin
                      .captureFingerPrintAsObject(textCtrl.text);
                  resultData = data.$2.toJson().toString();
                  await copyToClipboard(resultData);
                } catch (e, s) {
                  customToast(e.toString());
                  log(s.toString());
                }
                setState(() => showLoader = false);
              }),
              customButton("Capture FingerPrint as XML", () async {
                try {
                  setState(() => showLoader = true);
                  final data =
                      await _biometricAccessPlugin.captureFingerPrintAsXml(textCtrl.text);
                  resultData = (data);
                  await copyToClipboard(resultData);
                } catch (e, s) {
                  customToast(e.toString());
                  log(s.toString());
                }
                setState(() => showLoader = false);
              }),
            ],
          ),
        ),
        body: Stack(
          children: [
            if (showLoader) const Center(child: CircularProgressIndicator.adaptive()),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: responsive.height * .03),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FittedBox(
                        child: DropdownButton<RdServiceModel>(
                          hint: const Text(
                            "Discover RDService",
                            style: TextStyle(fontSize: 13),
                          ),
                          value: _biometricAccessPlugin.rdService,
                          items: (rdServiceList ?? []).map((value) {
                            return DropdownMenuItem<RdServiceModel>(
                              value: value,
                              child: Text(value.rdInfo ?? ""),
                            );
                          }).toList(),
                          onChanged: (val) {
                            _biometricAccessPlugin.setRDService = val!;
                            updateUi();
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        height: 20,
                        child: Text(
                            style:
                                const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            'Status: ${_biometricAccessPlugin.rdService?.rdStatus?.name ?? "Unavailable"}\n'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ...[
                    const Text(
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      'PidOptions:',
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      minLines: 2,
                      maxLines: 4,
                      controller: textCtrl,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (resultData != null) ...[
                    const Text(
                      "Device data",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      resultData ?? "",
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(height: 30),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> copyToClipboard(String? resultData) async {
    try {
      if (enableClipBoardCoping && resultData != null) {
        await Clipboard.setData(ClipboardData(text: resultData));
        customToast("Copied to Clipboard");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Widget customButton(String txt, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          txt,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}

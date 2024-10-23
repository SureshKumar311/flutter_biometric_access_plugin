import '../utils/biometric_access_enums.dart';

class RdServiceModel {
  final int? port;
  final List<BioMetricDevice> supportedDevices;
  RDStatus? rdStatus;
  String? rdInfo;
  String? deviceInfoPath;
  String? capturePath;

  RdServiceModel({
    this.supportedDevices = const [],
    required this.port,
    this.rdStatus,
    this.rdInfo,
    this.deviceInfoPath,
    this.capturePath,
  });

  factory RdServiceModel.fromMap(Map<String, dynamic> json, {int? port}) {
    String validatePath(String str) {
      if (str.isEmpty) {
        return str;
      } else {
        List<String> strList = str.split("/");
        if (strList.isNotEmpty && strList[1].contains("127.0.0.1")) strList.removeAt(1);
        return strList.join("/");
      }
    }

    List<Map<String, dynamic>> interface = List.from(json["RDService"]["Interface"] ?? []);

    return RdServiceModel(
      port: json["port"] ?? port,
      supportedDevices: BioMetricDevice.values
          .where((e) => e.rdService == json["RDService"]["info"])
          .toList(),
      rdStatus: mapStatusEnum((json["RDService"]["status"]) ?? ""),
      rdInfo: json["RDService"]["info"] ?? "",
      deviceInfoPath: interface.isEmpty
          ? null
          : validatePath(interface.firstWhere(((e) => e["id"] == "DEVICEINFO"))["path"]),
      capturePath: interface.isEmpty
          ? null
          : validatePath(interface.firstWhere(((e) => e["id"] == "CAPTURE"))["path"]),
    );
  }
}

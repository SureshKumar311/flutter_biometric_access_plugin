import 'dart:convert';

class DeviceInfoModel {
  final String? dpId;
  final String? rdsId;
  final String? rdsVer;
  final String? dc;
  final String? mi;
  final String? mc;
  final AdditionalInfo? additionalInfo;

  DeviceInfoModel({
    this.dpId,
    this.rdsId,
    this.rdsVer,
    this.dc,
    this.mi,
    this.mc,
    this.additionalInfo,
  });

  factory DeviceInfoModel.fromJson(String str) => DeviceInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeviceInfoModel.fromMap(Map<String, dynamic> json) {
    return DeviceInfoModel(
      dpId: json["dpId"],
      rdsId: json["rdsId"],
      rdsVer: json["rdsVer"],
      dc: json["dc"],
      mi: json["mi"],
      mc: json["mc"],
      additionalInfo: json["additional_info"] == null
          ? null
          : AdditionalInfo.fromMap(json["additional_info"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "dpId": dpId,
      "rdsId": rdsId,
      "rdsVer": rdsVer,
      "dc": dc,
      "mi": mi,
      "mc": mc,
      "additional_info": additionalInfo?.toMap(),
    };
  }
}

class AdditionalInfo {
  final List<Param>? param;

  AdditionalInfo({this.param});

  factory AdditionalInfo.fromJson(String str) => AdditionalInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AdditionalInfo.fromMap(Map<String, dynamic> json) {
    return AdditionalInfo(
      param: json["Param"] == null
          ? []
          : List<Param>.from(json["Param"]!.map((x) => Param.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Param": param == null ? [] : List<dynamic>.from(param!.map((x) => x.toMap())),
    };
  }
}

class Param {
  final String? name;
  final String? value;

  Param({
    this.name,
    this.value,
  });

  factory Param.fromJson(String str) => Param.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Param.fromMap(Map<String, dynamic> json) {
    return Param(
      name: json["name"],
      value: json["value"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
    };
  }
}

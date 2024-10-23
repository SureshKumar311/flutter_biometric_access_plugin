import 'dart:convert';

class PidDataModel {
  final PidData? pidData;

  PidDataModel({
    this.pidData,
  });

  factory PidDataModel.fromJson(String str) => PidDataModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PidDataModel.fromMap(Map<String, dynamic> json) => PidDataModel(
        pidData: json["PidData"] == null ? null : PidData.fromMap(json["PidData"]),
      );

  Map<String, dynamic> toMap() => {
        "PidData": pidData?.toMap(),
      };
}

class PidData {
  final Resp? resp;
  final DeviceInfo? deviceInfo;
  final Skey? skey;
  final Hmac? hmac;
  final Data? data;

  PidData({
    this.resp,
    this.deviceInfo,
    this.skey,
    this.hmac,
    this.data,
  });

  factory PidData.fromJson(String str) => PidData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PidData.fromMap(Map<String, dynamic> json) => PidData(
        resp: json["Resp"] == null ? null : Resp.fromMap(json["Resp"]),
        deviceInfo:
            json["DeviceInfo"] == null ? null : DeviceInfo.fromMap(json["DeviceInfo"]),
        skey: json["Skey"] == null ? null : Skey.fromMap(json["Skey"]),
        hmac: json["Hmac"] == null ? null : Hmac.fromMap(json["Hmac"]),
        data: json["Data"] == null ? null : Data.fromMap(json["Data"]),
      );

  Map<String, dynamic> toMap() => {
        "Resp": resp?.toMap(),
        "DeviceInfo": deviceInfo?.toMap(),
        "Skey": skey?.toMap(),
        "Hmac": hmac?.toMap(),
        "Data": data?.toMap(),
      };
}

class Data {
  final String? type;
  final String? value;

  Data({
    this.type,
    this.value,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "value": value,
      };
}

class DeviceInfo {
  final String? dpId;
  final String? rdsId;
  final String? rdsVer;
  final String? mi;
  final String? mc;
  final String? dc;
  final AdditionalInfo? additionalInfo;

  DeviceInfo({
    this.dpId,
    this.rdsId,
    this.rdsVer,
    this.mi,
    this.mc,
    this.dc,
    this.additionalInfo,
  });

  factory DeviceInfo.fromJson(String str) => DeviceInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeviceInfo.fromMap(Map<String, dynamic> json) => DeviceInfo(
        dpId: json["dpId"],
        rdsId: json["rdsId"],
        rdsVer: json["rdsVer"],
        mi: json["mi"],
        mc: json["mc"],
        dc: json["dc"],
        additionalInfo: json["additional_info"] == null
            ? null
            : AdditionalInfo.fromMap(json["additional_info"]),
      );

  Map<String, dynamic> toMap() => {
        "dpId": dpId,
        "rdsId": rdsId,
        "rdsVer": rdsVer,
        "mi": mi,
        "mc": mc,
        "dc": dc,
        "additional_info": additionalInfo?.toMap(),
      };
}

class AdditionalInfo {
  final List<Param>? param;

  AdditionalInfo({
    this.param,
  });

  factory AdditionalInfo.fromJson(String str) => AdditionalInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AdditionalInfo.fromMap(Map<String, dynamic> json) {
    return AdditionalInfo(
      param: json["Param"] == null
          ? []
          : json["Param"]
                  is List // Param cam an MAP or List<Map> depends on device response
              ? List<Param>.from([...(json["Param"])].map((x) => Param.fromMap(x)))
              : List<Param>.from([json["Param"]].map((x) => Param.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() => {
        "Param": param == null ? [] : List<dynamic>.from(param!.map((x) => x.toMap())),
      };
}

class Param {
  final String? name;
  final String? value;

  Param({this.name, this.value});

  factory Param.fromJson(String str) => Param.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Param.fromMap(Map<String, dynamic> json) {
    return Param(
      name: json["name"],
      value: json["value"],
    );
  }

  Map<String, dynamic> toMap() => {"name": name, "value": value};
}

class Hmac {
  final String? value;

  Hmac({
    this.value,
  });

  factory Hmac.fromJson(String str) => Hmac.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hmac.fromMap(Map<String, dynamic> json) => Hmac(
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
      };
}

///Use fcount or icount based on [FPD] or [IRIS] device type
class Resp {
  final String? errCode;
  final String? errInfo;
  final String? fCount;
  final String? fType;
  final String? iCount;
  final String? iType;
  final String? nmPoints;
  final String? qScore;

  Resp({
    this.errCode,
    this.errInfo,
    this.fCount,
    this.fType,
    this.iCount,
    this.iType,
    this.nmPoints,
    this.qScore,
  });

  factory Resp.fromJson(String str) => Resp.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Resp.fromMap(Map<String, dynamic> json) => Resp(
        errCode: json["errCode"],
        errInfo: json["errInfo"],
        fCount: json["fCount"],
        fType: json["fType"],
        iCount: json["iCount"],
        iType: json["iType"],
        nmPoints: json["nmPoints"],
        qScore: json["qScore"],
      );

  Map<String, dynamic> toMap() => {
        "errCode": errCode,
        "errInfo": errInfo,
        "fCount": fCount,
        "fType": fType,
        "iCount": iCount,
        "iType": iType,
        "nmPoints": nmPoints,
        "qScore": qScore,
      };
}

class Skey {
  final String? ci;
  final String? value;

  Skey({
    this.ci,
    this.value,
  });

  factory Skey.fromJson(String str) => Skey.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Skey.fromMap(Map<String, dynamic> json) => Skey(
        ci: json["ci"],
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "ci": ci,
        "value": value,
      };
}

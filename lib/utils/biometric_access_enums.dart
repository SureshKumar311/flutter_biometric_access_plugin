// ignore_for_file: constant_identifier_names

enum RDStatus { NOTREADY, READY }

RDStatus mapStatusEnum(String status) {
  switch (status.toUpperCase()) {
    case "READY":
      return RDStatus.READY;
    case "NOTREADY":
    default:
      return RDStatus.NOTREADY;
  }
}

enum BioMetricDevice {
  mantra,
  mantra_L1,
  mantra_L1_IRIS,
  morpho,
  morpho_L1,
  // secugen,
  // evolute,
  // startek,
  // startek_L1,
  // tatvik,
  // nextbiometrics,
  // aratek,
}

BioMetricDevice getBioMetricDevicesByEnumName(String deviceName) =>
    BioMetricDevice.values.firstWhere((e) => e.name == deviceName);

enum DeviceType { IRIS, FPD }

extension BioDeviceExt on BioMetricDevice {
  bool get enableBioDevice {
    switch (this) {
      case BioMetricDevice.mantra:
      case BioMetricDevice.morpho:
      case BioMetricDevice.mantra_L1:
      case BioMetricDevice.morpho_L1:
      case BioMetricDevice.mantra_L1_IRIS:
        return true;
    }
  }

//TODO Add other devices and versions (L1)
  String get rdService {
    switch (this) {
      case BioMetricDevice.mantra:
      case BioMetricDevice.mantra_L1:
        return "Mantra Authentication Vendor Device Manager";
      case BioMetricDevice.mantra_L1_IRIS:
        return "Mantra Iris Authentication Vendor Device Manager";
      case BioMetricDevice.morpho:
      case BioMetricDevice.morpho_L1:
        return "Morpho_RD_Service";
    }
  }

  DeviceType getDeviceType() {
    switch (this) {
      case BioMetricDevice.mantra:
      case BioMetricDevice.mantra_L1:
      case BioMetricDevice.morpho:
      case BioMetricDevice.morpho_L1:
        return DeviceType.FPD;
      case BioMetricDevice.mantra_L1_IRIS:
        return DeviceType.IRIS;
    }
  }
}

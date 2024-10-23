import 'package:biometric_access/model/rd_services_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'biometric_access_platform_interface.dart';

/// An implementation of [BiometricAccessPlatform] that uses method channels.
class MethodChannelBiometricAccess extends BiometricAccessPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('biometric_access');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future captureFingerPrint(String pidOptions, {int? port, String? path}) async {
    final result =
        await methodChannel.invokeMethod<String>('mantra', {"pidOptions": pidOptions});
    return result;
  }

  @override
  Future<String?> getDeviceInfo({int? port, String? path}) async {
    final result = await methodChannel.invokeMethod<String>('deviceInfo');
    return result;
  }

  @override
  Future<List<RdServiceModel>> discoverRDServices() {
    throw UnimplementedError('discoverRDServices() does not support Android Platform');
  }
}

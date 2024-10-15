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
}

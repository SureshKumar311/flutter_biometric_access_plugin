import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'biometric_access_method_channel.dart';

abstract class BiometricAccessPlatform extends PlatformInterface {
  /// Constructs a BiometricAccessPlatform.
  BiometricAccessPlatform() : super(token: _token);

  static final Object _token = Object();

  static BiometricAccessPlatform _instance = MethodChannelBiometricAccess();

  /// The default instance of [BiometricAccessPlatform] to use.
  ///
  /// Defaults to [MethodChannelBiometricAccess].
  static BiometricAccessPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BiometricAccessPlatform] when
  /// they register themselves.
  static set instance(BiometricAccessPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}


import 'biometric_access_platform_interface.dart';

class BiometricAccess {
  Future<String?> getPlatformVersion() {
    return BiometricAccessPlatform.instance.getPlatformVersion();
  }
}

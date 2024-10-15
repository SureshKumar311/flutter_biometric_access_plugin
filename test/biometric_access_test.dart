import 'package:flutter_test/flutter_test.dart';
import 'package:biometric_access/biometric_access.dart';
import 'package:biometric_access/biometric_access_platform_interface.dart';
import 'package:biometric_access/biometric_access_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBiometricAccessPlatform
    with MockPlatformInterfaceMixin
    implements BiometricAccessPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BiometricAccessPlatform initialPlatform = BiometricAccessPlatform.instance;

  test('$MethodChannelBiometricAccess is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBiometricAccess>());
  });

  test('getPlatformVersion', () async {
    BiometricAccess biometricAccessPlugin = BiometricAccess();
    MockBiometricAccessPlatform fakePlatform = MockBiometricAccessPlatform();
    BiometricAccessPlatform.instance = fakePlatform;

    expect(await biometricAccessPlugin.getPlatformVersion(), '42');
  });
}

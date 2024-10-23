import 'package:biometric_access/biometric_access.dart';
import 'package:biometric_access/biometric_access_method_channel.dart';
import 'package:biometric_access/biometric_access_platform_interface.dart';
import 'package:biometric_access/model/rd_services_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBiometricAccessPlatform
    with MockPlatformInterfaceMixin
    implements BiometricAccessPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future captureFingerPrint(String pidOptions, {int? port, String? path}) {
    // TODO: implement getMantra
    throw UnimplementedError();
  }

  @override
  Future<List<RdServiceModel>> discoverRDServices() {
    // TODO: implement discoverRDServices
    throw UnimplementedError();
  }

  @override
  Future<String?> getDeviceInfo({int? port, String? path}) {
    // TODO: implement getDeviceInfo
    throw UnimplementedError();
  }
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

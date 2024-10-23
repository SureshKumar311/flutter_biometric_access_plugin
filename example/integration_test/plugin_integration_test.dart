// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:biometric_access/biometric_access.dart';
import "package:biometric_access_example/main.dart" as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
void main() async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('screenshot', (WidgetTester tester) async {
    // Build the app.
    app.main();

    // Trigger a frame.
    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-1');
  });

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    final BiometricAccess plugin = BiometricAccess();
    final String? version = await plugin.getPlatformVersion();
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(version?.isNotEmpty, true);
  });
}

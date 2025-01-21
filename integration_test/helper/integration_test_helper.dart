import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:asset_tracker/main.dart' as app;
import 'package:integration_test/integration_test.dart';

final class IntegrationTestHelper {
  IntegrationTestHelper._();

  static void initailize() {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    WidgetsFlutterBinding.ensureInitialized();
  }

  static void startApp() => app.main();

  static Future<void> waitFrame(WidgetTester tester, [int? seconds]) async {
    if (seconds == null || seconds <= 0) {
      await tester.pumpAndSettle();
    } else {
      await tester.pumpAndSettle(Duration(seconds: seconds));
    }
  }

  static Future<void> pumpFrame(WidgetTester tester) async =>
      await tester.pump();
}

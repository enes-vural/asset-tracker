import 'package:flutter_test/flutter_test.dart';

final class IntegrationTestHelper {
  IntegrationTestHelper._();

  static Future<void> waitFrame(WidgetTester tester, int? seconds) async =>
      await tester.pumpAndSettle(Duration(seconds: seconds ?? 0));

  static Future<void> pumpFrame(WidgetTester tester) async =>
      await tester.pump();
}

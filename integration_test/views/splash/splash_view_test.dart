import 'package:asset_tracker/core/config/constants/global/key/widget_keys.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:asset_tracker/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();
  group("Splash View UI test", () {
    testWidgets(
      "does circle logo shows on initial ?",
      (WidgetTester tester) async {
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 2));
        final splashWidget = find.byKey(WidgetKeys.splashLogoKey);
        expect(splashWidget, findsOneWidget);
      },
    );
  });
}

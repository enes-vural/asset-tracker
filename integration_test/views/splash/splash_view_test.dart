import 'package:asset_tracker/core/config/constants/global/key/widget_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helper/integration_test_helper.dart';

void main() {
  IntegrationTestHelper.initailize();

  setUp(() async {
    IntegrationTestHelper.startApp();
  });
  group("Splash View UI test", () {
    testWidgets(
      "does circle logo shows on initial ?",
      (WidgetTester tester) async {
        await IntegrationTestHelper.waitFrame(tester, 2);

        final splashWidget = find.byKey(WidgetKeys.splashLogoKey);
        
        expect(splashWidget, findsOneWidget);
      },
    );
  });
}

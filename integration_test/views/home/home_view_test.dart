import 'package:asset_tracker/core/config/constants/global/key/widget_keys.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../helper/integration_test_helper.dart';

void main() {
  IntegrationTestHelper.initailize();

  setUp(() async {
    IntegrationTestHelper.startApp();
  });

  group("Home View UI Test Group", () {
    testWidgets(
      "does home view's components are visible ?",
      (WidgetTester tester) async {
        //setup mocks for pass the auth safely
        await IntegrationTestHelper.waitFrame(tester, 4);

        final emailField = find.byKey(WidgetKeys.loginEmailTextFieldKey);
        final passwordField = find.byKey(WidgetKeys.loginPasswordTextFieldKey);
        final loginButton = find.byKey(WidgetKeys.loginSubmitButtonKey);

        //enterText needs for the string validation
        await tester.enterText(emailField, "test@gmail.com");
        await tester.enterText(passwordField, "123456");

        await tester.tap(loginButton);

        await IntegrationTestHelper.waitFrame(tester, 4);
        //auth has been passed
        expect(find.text(LocaleKeys.app_title.tr()), findsOneWidget);

        //data has come from the api
        //expect(find.text(LocaleKeys.home_widget_altin.tr()), findsWidgets);
        // await tester.scrollUntilVisible(
        //     find.text(LocaleKeys.home_widget_paladyum.tr()), 50,
        //     maxScrolls: 50);
        // await IntegrationTestHelper.pumpFrame(tester);
        // expect(find.text(LocaleKeys.home_widget_paladyum.tr()), findsOneWidget);
      },
    );
  });
}

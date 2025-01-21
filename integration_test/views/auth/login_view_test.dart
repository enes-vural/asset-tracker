import 'package:asset_tracker/core/config/constants/global/key/widget_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper/integration_test_helper.dart';
import 'constants.dart';
import 'model/auth_test_cases_model.dart';

void main() {
  IntegrationTestHelper.initailize();
  group("Login View Test Group", () {
    setUp(() async {
      IntegrationTestHelper.startApp();
    });

    testWidgets(
      "does login view's components are visible ?",
      (WidgetTester tester) async {
        await IntegrationTestHelper.waitFrame(tester, 4);

        final emailField = find.byKey(WidgetKeys.loginEmailTextFieldKey);
        final passwordField = find.byKey(WidgetKeys.loginPasswordTextFieldKey);
        final appLogo = find.byKey(WidgetKeys.loginAppLogoKey);
        final signInText = find.byKey(WidgetKeys.loginSignInTextKey);
        final submitWidget = find.byKey(WidgetKeys.loginSubmitButtonKey);

        expect(emailField, findsOneWidget);
        expect(passwordField, findsOneWidget);
        expect(signInText, findsOneWidget);
        expect(appLogo, findsOneWidget);
        expect(submitWidget, findsOneWidget);
      },
    );

    for (AuthTestCasesModel testCase in AuthTestConstants.validationTestCases) {
      testWidgets(
        "Validation Testing email [${testCase.email}] and password [${testCase.password}]",
        (WidgetTester tester) async {
          await IntegrationTestHelper.waitFrame(tester, 4);

          final emailField = find.byKey(WidgetKeys.loginEmailTextFieldKey);
          final passwordField =
              find.byKey(WidgetKeys.loginPasswordTextFieldKey);
          final submitWidget = find.byKey(WidgetKeys.loginSubmitButtonKey);

          await tester.enterText(emailField, testCase.email);
          await tester.enterText(passwordField, testCase.password);

          await tester.tap(submitWidget);
          await IntegrationTestHelper.waitFrame(tester);

          expect(find.text(testCase.expectedMessage.tr()), findsWidgets);
        },
      );
    }

    for (AuthTestCasesModel testCase in AuthTestConstants.authFailTestCases) {
      testWidgets(
        "Authentication Fail Testing email [${testCase.email}] and password [${testCase.password}]",
        (WidgetTester tester) async {
          await IntegrationTestHelper.waitFrame(tester, 4);

          final emailField = find.byKey(WidgetKeys.loginEmailTextFieldKey);
          final passwordField =
              find.byKey(WidgetKeys.loginPasswordTextFieldKey);
          final submitWidget = find.byKey(WidgetKeys.loginSubmitButtonKey);

          await tester.enterText(emailField, testCase.email);
          await tester.enterText(passwordField, testCase.password);

          await tester.tap(submitWidget);
          await IntegrationTestHelper.waitFrame(tester);

          //snackbar should visible
          expect(find.byType(SnackBar), findsOneWidget);
          //snackbar should have expected message
          expect(find.text(testCase.expectedMessage.tr()), findsWidgets);

          await IntegrationTestHelper.waitFrame(tester);
          //snackbar should not visible after duration
          expect(find.byType(SnackBar), findsNothing);
        },
      );
    }
  });
}

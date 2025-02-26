import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'model/auth_test_cases_model.dart';

final class AuthTestConstants {
  /// Vadilation test email and password
  static const String none = "";
  static const String correctEmail = "ui-test@gmail.com";
  static const String weakEmail = "wrong-email.com";
  static const String weakPassword = "123";
  static const String correctPassword = "123456789";

  /// Auth test email and password (DB)
  static const String authEmail = "test@gmail.com";
  static const String authPassword = "123456";

  static final List<AuthTestCasesModel> validationTestCases = [
    const AuthTestCasesModel(
      email: none,
      password: correctPassword,
      expectedMessage: LocaleKeys.auth_validation_noneEmail,
    ),
    const AuthTestCasesModel(
      email: weakEmail,
      password: correctPassword,
      expectedMessage: LocaleKeys.auth_validation_weakEmail,
    ),
    const AuthTestCasesModel(
      email: correctEmail,
      password: none,
      expectedMessage: LocaleKeys.auth_validation_nonePassword,
    ),
    const AuthTestCasesModel(
      email: correctEmail,
      password: weakPassword,
      expectedMessage: LocaleKeys.auth_validation_weakPassword,
    ),
  ];

  static final List<AuthTestCasesModel> authFailTestCases = [
    const AuthTestCasesModel(
        email: correctEmail,
        password: correctPassword,
        expectedMessage: LocaleKeys.auth_response_invalidCred),
    //wifi kapatılıp timeout , veya general err test edilebilir
  ];
}

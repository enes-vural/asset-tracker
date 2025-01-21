import 'package:flutter/material.dart';

final class WidgetKeys {
  const WidgetKeys._();

  /// Splash View ///
  static const ValueKey splashLogoKey = ValueKey("splash_logo_widget");
  //-----------------

  /// Login View ///
  static const ValueKey loginSubmitButtonKey =
      ValueKey("login_submit_button_widget");
  static const ValueKey loginAppLogoKey = ValueKey("login_app_logo_widget");
  static const ValueKey loginSignInTextKey = ValueKey("login_sign_in_text");

  static const ValueKey loginEmailTextFieldKey =
      ValueKey("login_email_text_field");
  static const ValueKey loginPasswordTextFieldKey =
      ValueKey("login_password_text_field");
  //-----------------
}

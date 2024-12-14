
///Auth Error Types
final class AuthErrorState {
  static const String ACCOUNT_EXIST =
      "account-exists-with-different-credential";
  static const String NOT_FOUND = "user-not-found";
  static const String WRONG_PASSWORD = "wrong-password";
  static const String INVALID_EMAIL = "invalid-email";
  static const String USER_DISABLED = "user-disabled";
  static const String REQUEST_QUOTA = "too-many-requests";
  static const String INVALID_CRED = "invalid-credential";
  static const String TIMEOUT = "timeout";
  static const String GENERAL_ERR = "general-err";

}

// ignore_for_file: non_constant_identifier_names

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

  String getAuthErrorState(String errorCode) {
    switch (errorCode) {
      case "account-exists-with-different-credential":
        return AuthErrorState.ACCOUNT_EXIST;
      case "user-not-found":
        return AuthErrorState.NOT_FOUND;
      case "wrong-password":
        return AuthErrorState.WRONG_PASSWORD;
      case "invalid-email":
        return AuthErrorState.INVALID_EMAIL;
      case "user-disabled":
        return AuthErrorState.USER_DISABLED;
      case "too-many-requests":
        return AuthErrorState.REQUEST_QUOTA;
      case "invalid-credentinals":
        return AuthErrorState.INVALID_CRED;
      case "timeout":
        return AuthErrorState.TIMEOUT;
      case "not-found":
        return AuthErrorState.NOT_FOUND; // Default case if error is unknown
      default:
        return AuthErrorState.GENERAL_ERR;
    }
  }
}

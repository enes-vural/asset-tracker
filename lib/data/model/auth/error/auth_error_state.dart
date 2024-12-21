///Auth Error Types
///
//Default String Constants sınıfından farklı bir sınıf olarak tanımladım burasınını
//
enum AuthErrorState {
  ACCOUNT_EXIST("account-exists-with-different-credential"),
  NOT_FOUND("user-not-found"),
  WRONG_PASSWORD("wrong-password"),
  INVALID_EMAIL("invalid-email"),
  USER_DISABLED("user-disabled"),
  REQUEST_QUOTA("too-many-requests"),
  INVALID_CRED("invalid-credential"),
  TIMEOUT("timeout"),
  GENERAL_ERR("general-err");

  final String value;
  const AuthErrorState(this.value);
}

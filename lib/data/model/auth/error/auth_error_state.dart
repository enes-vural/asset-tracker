///Auth Error Types
///
//Default String Constants sınıfından farklı bir sınıf olarak tanımladım burasınını
//
enum AuthErrorState {
  //------- LOGIN ERROR --------
  ACCOUNT_EXIST("account-exists-with-different-credential"),
  NOT_FOUND("user-not-found"),
  WRONG_PASSWORD("wrong-password"),
  INVALID_EMAIL("invalid-email"),
  USER_DISABLED("user-disabled"),
  REQUEST_QUOTA("too-many-requests"),
  INVALID_CRED("invalid-credential"),
  TIMEOUT("timeout"),
  GENERAL_ERR("general-err"),

  //------- REGISTER ERROR --------
  EMAIL_EXISTS("email-already-in-use"),
  WEAK_PASSWORD("weak-password"),
  OPERATION_NOT_ALLOWED("operation-not-allowed"),
  TOO_MANY_REQUESTS("too-many-requests"),
  NETWORK_ERROR("network-request-failed"),
  USER_TOKEN_EXPIRED("user-token-expired");

  final String value;
  const AuthErrorState(this.value);
}

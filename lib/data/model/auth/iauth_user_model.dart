abstract interface class IAuthenticationUserModel {
  String? get displayName;
  String? get email;
  String? get uid;
  bool? get emailVerified;
  String? get idToken;
}

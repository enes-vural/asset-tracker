import 'package:firebase_auth/firebase_auth.dart';

//MockUserCredentialsModel sınıfı UserCredential sınıfını implemente eder.
//Bu sınıfın amacı imock_auth_service.dart dosyasındaki return Type'ın UserCredential
//olmasından kaynaklanır.
//Bu sınıf FirebaseAuth dan gelenn UserCredential sınıfını implemente eder.
//Bu sınıfın amacı mock bir UserCredential sınıfı oluşturmak ve bu sınıfı
//MockAuthService sınıfına döndürmektir.
//Sadece gerekli parametrelerin içini doldurdum diğer taraftan gerek olmayan parametreler
//throw UnimplementedError() ile bırakıldı.

class MockUserCredentialsModel implements UserCredential {
  final User mockUser = MockUserModel();

  @override
  AdditionalUserInfo? get additionalUserInfo => throw UnimplementedError();

  @override
  AuthCredential? get credential => throw UnimplementedError();

  @override
  User? get user => mockUser;
}

//MockUser sınıfı FirebaseAuth'dan gelen User sınıfı ile implemente edildi.
//Bu sınıfın amacı MockUserCredentials sınıfının ihtiyacı olan User nesnesinin
//mocklanarak sağlanması.
//Burada önemli olan değerler 'uid' ve 'email' değerleridir.
//Bu değerlerin dışında diğer değerlerin önemi yoktur.

class MockUserModel implements User {
  @override
  String? get displayName => "Tester";

  @override
  String? get email => "tester@mockdata.com";

  @override
  String get uid => "tester-account-mock-uid";

  @override
  bool get emailVerified => true;

  @override
  Future<String?> getIdToken([bool forceRefresh = false]) {
    return Future.delayed(const Duration(seconds: 1), () => 'userIDToken');
  }

  //
  //
  //
  //
  //
  // The following methods are not implemented in this mock class
  // -----------------------------------------------
  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) {
    throw UnimplementedError();
  }

  @override
  bool get isAnonymous => throw UnimplementedError();

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) {
    throw UnimplementedError();
  }

  @override
  Future<ConfirmationResult> linkWithPhoneNumber(String phoneNumber,
      [RecaptchaVerifier? verifier]) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> linkWithPopup(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<void> linkWithRedirect(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  UserMetadata get metadata => throw UnimplementedError();

  @override
  MultiFactor get multiFactor => throw UnimplementedError();

  @override
  String? get phoneNumber => throw UnimplementedError();

  @override
  String? get photoURL => throw UnimplementedError();

  @override
  List<UserInfo> get providerData => throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithCredential(
      AuthCredential credential) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> reauthenticateWithPopup(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> reauthenticateWithProvider(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<void> reauthenticateWithRedirect(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  String? get refreshToken => throw UnimplementedError();

  @override
  Future<void> reload() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) {
    throw UnimplementedError();
  }

  @override
  String? get tenantId => throw UnimplementedError();

  @override
  Future<User> unlink(String providerId) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateDisplayName(String? displayName) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateEmail(String newEmail) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword(String newPassword) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePhotoURL(String? photoURL) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) {
    throw UnimplementedError();
  }

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail,
      [ActionCodeSettings? actionCodeSettings]) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete() {
    throw UnimplementedError();
  }
  //-----------------------------------------------
  /// The following methods are not implemented in this mock class
}

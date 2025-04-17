import 'package:firebase_auth/firebase_auth.dart';

class MockUserCredentinal implements UserCredential {
  @override
  AdditionalUserInfo? get additionalUserInfo => throw UnimplementedError();

  @override
  AuthCredential? get credential => throw UnimplementedError();

  @override
  User? get user => throw UnimplementedError();
}

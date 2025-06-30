import 'package:asset_tracker/data/model/auth/iauth_user_model.dart';

class MockAuthUserModel implements IAuthenticationUserModel {
  @override
  final String displayName;
  @override
  final String email;
  @override
  final String uid;
  @override
  final bool emailVerified;
  @override
  final String? idToken;

  const MockAuthUserModel({
    required this.displayName,
    required this.email,
    required this.uid,
    required this.emailVerified,
    required this.idToken,
  });
}

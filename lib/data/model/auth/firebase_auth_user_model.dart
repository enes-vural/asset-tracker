import 'package:asset_tracker/data/model/auth/iauth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthUser implements IAuthenticationUserModel {
  @override
  final String? displayName;
  @override
  final String? email;
  @override
  final String? uid;
  @override
  final bool? emailVerified;
  @override
  final String? idToken;

  final User? user;

  const FirebaseAuthUser(
      {required this.displayName,
      required this.email,
      required this.uid,
      required this.emailVerified,
      required this.user,
      required this.idToken});
}

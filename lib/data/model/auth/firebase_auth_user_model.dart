import 'package:asset_tracker/data/model/auth/iauth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthUser implements IAuthenticationUserModel {
  @override
  String? get displayName => user?.displayName;
  @override
  String? get email => user?.email;
  @override
  String? get uid => user?.uid;
  @override
  bool? get emailVerified => user?.emailVerified;
  @override
  final String? idToken;

  final User? user;

  const FirebaseAuthUser({required this.user, required this.idToken});
}

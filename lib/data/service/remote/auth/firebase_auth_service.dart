import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/data/service/remote/auth/ifirebase_auth_service.dart';
import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements IFirebaseAuthService {
  final FirebaseAuth authService;
  FirebaseAuthService({required this.authService});

  @override
  Future<FirebaseAuthUser>? signInUser(UserLoginEntity entity) async {
    final response = await authService.signInWithEmailAndPassword(
        email: entity.userName, password: entity.password);

    return _combineUserData(response);
  }

  Future<FirebaseAuthUser> _combineUserData(UserCredential creds) async {
    final getIdToken = await creds.user?.getIdToken();
    return FirebaseAuthUser(
      displayName: creds.user?.displayName,
      email: creds.user?.email,
      uid: creds.user?.uid,
      emailVerified: creds.user?.emailVerified,
      user: creds.user,
      idToken: getIdToken,
    );
  }
}

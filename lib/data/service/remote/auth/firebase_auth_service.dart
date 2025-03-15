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

  @override
  String? getUserId() {
    return authService.currentUser?.uid;
  }

  @override
  Stream getUserStateChanges() {
    return authService.authStateChanges();
  }

  Future<FirebaseAuthUser> _combineUserData(UserCredential creds) async {
    final getIdToken = await creds.user?.getIdToken();
    return FirebaseAuthUser(
      user: creds.user,
      idToken: getIdToken,
    );
  }

  @override
  Future<void> signOutUser() async {
    return await authService.signOut();
  }
}

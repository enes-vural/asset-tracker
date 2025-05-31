import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';
import 'package:asset_tracker/data/service/remote/auth/ifirebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements IFirebaseAuthService {
  final FirebaseAuth authService;
  FirebaseAuthService({required this.authService});

  @override
  Future<FirebaseAuthUser>? signInUser(UserLoginModel model) async {
    final response = await authService.signInWithEmailAndPassword(
        email: model.userName, password: model.password);

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

  @override
  Future<UserCredential> registerUser(UserRegisterModel model) async {
    return await authService.createUserWithEmailAndPassword(
        email: model.userName, password: model.password);
  }
}

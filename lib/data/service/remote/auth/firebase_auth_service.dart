import 'package:asset_tracker/data/model/auth/error/auth_response_model.dart';
import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';
import 'package:asset_tracker/data/service/remote/auth/ifirebase_auth_service.dart';
import 'package:dartz/dartz.dart';
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

  //gereksiz değil anlamlı soyutlama bi email stringi için entity model yazmayı gerek görmedim.
  @override
  Future<void> sendResetPasswordLink(String email) async {
    return await authService.sendPasswordResetEmail(email: email);
  }

  Future<Either<AuthErrorModel, bool>> deleteAccount() async {
    final user = authService.currentUser;
    if (user != null) {
      try {
        await user.delete();
        return const Right(true);
      } on FirebaseAuthException catch (e) {
        return Left(AuthErrorModel.fromErrorCode(e.code));
      }
    }
    //TODO: Burası temizlenmesi lazım
    return Left(AuthErrorModel.fromErrorCode("requires-recent-login"));
  }

  @override
  Future<UserCredential> registerUser(UserRegisterModel model) async {
    return await authService.createUserWithEmailAndPassword(
        email: model.userName, password: model.password);
  }
}

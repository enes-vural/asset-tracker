import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_login_entity.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_register_entity.dart';
import 'package:asset_tracker/domain/entities/auth/response/user_register_reponse_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:dartz/dartz.dart';
import '../../entities/auth/error/auth_error_entity.dart';
import '../../entities/auth/response/user_login_response_entity.dart';

abstract interface class IAuthRepository {
  String? getUserId();
  Stream getUserStateChanges();
  Future<void> signOut();
  Future<Either<AuthErrorEntity, bool>> deleteAccount();
  Future<Either<DatabaseErrorEntity, bool>> sendEmailVerification();
}

abstract interface class IEmailAuthRepository extends IAuthRepository {
  Future<Either<AuthErrorEntity, UserLoginResponseEntity>> signIn(
      UserLoginEntity entity);
  Future<Either<AuthErrorEntity, UserRegisterReponseEntity>> registerUser(
      UserRegisterEntity entity);
  Future<void> sendResetPasswordLink(String email);
}

abstract interface class ISocialAuthRepository extends IAuthRepository {
  Future<FirebaseAuthUser?> signInWithGoogle();
  Future<FirebaseAuthUser?> signInWithApple();
  Future<void> initializeServices();
}

import 'package:asset_tracker/domain/entities/auth/request/user_login_entity.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_register_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:dartz/dartz.dart';

import '../../entities/auth/error/auth_error_entity.dart';
import '../../entities/auth/response/user_login_response_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<AuthErrorEntity, UserLoginResponseEntity>> signIn(
      UserLoginEntity entity);

  Future registerUser(UserRegisterEntity entity);

  String? getUserId();

  Stream getUserStateChanges();

  Future<void> signOut();

  Future<void> sendResetPasswordLink(String email);

  Future<Either<AuthErrorEntity, bool>> deleteAccount();

  Future<Either<DatabaseErrorEntity, bool>> sendEmailVerification();
}

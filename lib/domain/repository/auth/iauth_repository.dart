import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';
import 'package:dartz/dartz.dart';

import '../../entities/auth/error/auth_error_entity.dart';
import '../../entities/auth/user_login_response_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<AuthErrorEntity, UserLoginResponseEntity>> signIn(
      UserLoginEntity entity);

  String? getUserId();

  Stream getUserStateChanges();
}

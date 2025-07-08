import 'package:asset_tracker/domain/entities/auth/error/auth_error_entity.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_register_entity.dart';
import 'package:asset_tracker/domain/entities/auth/response/user_register_reponse_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:asset_tracker/domain/usecase/base/base_use_case.dart';
import 'package:dartz/dartz.dart';
import '../../entities/auth/response/user_login_response_entity.dart';

class AuthUseCase implements BaseUseCase {
  final IEmailAuthRepository _authRepository;

  const AuthUseCase(this._authRepository);

  @override
  Future<Either<AuthErrorEntity, UserLoginResponseEntity>> call(params) async {
    return await _authRepository.signIn(params);
  }

  Future<Either<AuthErrorEntity, UserRegisterReponseEntity>> registerUser(
      UserRegisterEntity entity) async {
    return await _authRepository.registerUser(entity);
  }

  //sign out için ayrı use case açılabilir. ama şimdilik gerek yok.
  Future<void> signOut() async {
    return await _authRepository.signOut();
  }

  Future<Either<AuthErrorEntity, bool>> deleteAccount() async {
    return await _authRepository.deleteAccount();
  }

  Future<void> sendResetPasswordLink(String email) async {
    return await _authRepository.sendResetPasswordLink(email);
  }

  Future<Either<DatabaseErrorEntity, bool>> sendEmailVerification() async {
    return await _authRepository.sendEmailVerification();
  }
}

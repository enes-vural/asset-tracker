import 'package:asset_tracker/domain/entities/auth/error/auth_error_entity.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:asset_tracker/domain/usecase/base/base_use_case.dart';
import 'package:dartz/dartz.dart';

import '../../entities/auth/user_login_response_entity.dart';

class SignInUseCase implements BaseUseCase {
  final IAuthRepository _authRepository;

  const SignInUseCase(this._authRepository);

  @override
  Future<Either<AuthErrorEntity, UserLoginResponseEntity>> call(params) async {
    return await _authRepository.signIn(params);
  }
  //sign out için ayrı use case açılabilir. ama şimdilik gerek yok.
  Future<void> signOut() async {
    return await _authRepository.signOut();
  }
}

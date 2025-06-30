import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';
import 'package:asset_tracker/domain/repository/auth/igoogle_sign_in_repository.dart';
import 'package:asset_tracker/domain/usecase/base/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GoogleSigninUseCase implements BaseUseCase {
  final IGoogleSignInRepository _authRepository;

  const GoogleSigninUseCase(this._authRepository);

  @override
  Future<Either<BaseErrorEntity, dynamic>> call(params) {
    throw UnimplementedError();
  }

  Future<void> initializeGoogleSignIn() async {
    await _authRepository.initialize();
  }

  Future<Either<BaseErrorEntity, dynamic>> signInWithGoogle() async {
    try {
      final result = await _authRepository.signInWithGoogle();
      if (result != null) {
        return Right(result);
      } else {
        return const Left(BaseErrorEntity(message: "Google Sign-In failed"));
      }
    } catch (e) {
      return Left(BaseErrorEntity(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}

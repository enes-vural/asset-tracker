import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:asset_tracker/domain/usecase/base/base_use_case.dart';
import 'package:dartz/dartz.dart';

class SocialSignInUseCase implements BaseUseCase {
  final ISocialAuthRepository _authRepository;

  const SocialSignInUseCase(this._authRepository);

  @override
  Future<Either<BaseErrorEntity, dynamic>> call(params) {
    throw UnimplementedError();
  }

  Future<void> initializeServices() async {
    await _authRepository.initializeServices();
  }

  Future<Either<BaseErrorEntity, FirebaseAuthUser?>> signInWithGoogle() async {
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

  Future<void> signInWithApple() async {
    await _authRepository.signInWithApple();
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}

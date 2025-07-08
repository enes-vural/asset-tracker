import 'package:asset_tracker/data/service/remote/auth/iauth_service.dart';
import 'package:asset_tracker/domain/entities/auth/error/auth_error_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:dartz/dartz.dart';

class BaseAuthRepository implements IAuthRepository {
  final IAuthService authService;

  BaseAuthRepository({required this.authService});

  @override
  String? getUserId() => authService.getUserId();

  @override
  Stream getUserStateChanges() => authService.getUserStateChanges();

  @override
  Future<void> signOut() async => await authService.signOutUser();

  @override
  Future<Either<AuthErrorEntity, bool>> deleteAccount() async {
    final data = await authService.deleteAccount();
    return data.fold(
      (failure) => Left(AuthErrorEntity.fromModel(failure)),
      (success) => Right(success),
    );
  }

  @override
  Future<Either<DatabaseErrorEntity, bool>> sendEmailVerification() async {
    final user = await authService.sendEmailVerification();

    return user.fold(
      (failure) {
        return Left(DatabaseErrorEntity.fromModel(failure));
      },
      (success) {
        return Right(success);
      },
    );
  }
}

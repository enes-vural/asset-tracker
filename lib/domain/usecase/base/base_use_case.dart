import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';
import 'package:dartz/dartz.dart';

abstract class BaseUseCase<Type, Params> {
  Future<Either<BaseErrorEntity, Type>> call(Params params);
}

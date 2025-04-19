import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';
import 'package:dartz/dartz.dart';

/// BaseUseCase is a generic class that defines the contract for use cases.
/// Generally uses for business logic which has return error or success (either) type.
abstract class BaseUseCase<Type, Params> {
  Future<Either<BaseErrorEntity, Type>> call(Params params);
}

/// BaseVoidUseCase is a generic class that defines the contract for use cases.
/// Generally uses for business logic which does not return any value.
/// It is used for void return type and some operations which we dont want to return error state.
abstract class BaseFreeUseCase<Type, Params> {
  Future<dynamic> call(Params params);
}

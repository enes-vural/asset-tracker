import 'package:asset_tracker/data/model/database/response/asset_code_model.dart'
    show AssetCodeModel;
import 'package:asset_tracker/domain/entities/database/database_error_entity.dart';
import 'package:dartz/dartz.dart' show Either;

abstract interface class IFirestoreRepository {
  Future<Either<DatabaseErrorEntity, List<AssetCodeModel>>> getAssetCodes();
}

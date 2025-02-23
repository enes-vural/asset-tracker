import 'package:asset_tracker/data/model/database/error/database_error_model.dart'
    show DatabaseErrorModel;
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart'
    show AssetCodeModel;
import 'package:dartz/dartz.dart' show Either;

abstract interface class IDatabaseService {
  Future<void> buyCurrency();

  Future<void> sellCurrency();

  Future<Either<DatabaseErrorModel, List<AssetCodeModel>>> getAssetCodes();
}

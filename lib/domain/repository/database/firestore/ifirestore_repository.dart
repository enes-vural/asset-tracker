import 'package:asset_tracker/data/model/database/response/asset_code_model.dart'
    show AssetCodeModel;
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:dartz/dartz.dart' show Either;

abstract interface class IFirestoreRepository {
  Future<Either<DatabaseErrorEntity, List<AssetCodeModel>>> getAssetCodes();

  Future<Either<DatabaseErrorEntity, BuyCurrencyEntity>> buyCurrency(
      BuyCurrencyEntity entity);
}

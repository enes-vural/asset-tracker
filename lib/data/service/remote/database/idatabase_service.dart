import 'package:asset_tracker/data/model/database/error/database_error_model.dart'
    show DatabaseErrorModel;
import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';
import 'package:asset_tracker/data/model/database/request/user_uid_model.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart'
    show AssetCodeModel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart' show Either;

abstract interface class IDatabaseService {
  Future<Either<DatabaseErrorModel, BuyCurrencyModel>> buyCurrency(
      BuyCurrencyModel model);

  Future<void> sellCurrency();

  Future<Either<DatabaseErrorModel, List<AssetCodeModel>>> getAssetCodes();

  //burada document snapshot verilmemeli ortak sınıftan türetilmeli yoksa SOLID e aykırı olur
  //TODO:
  Future<Either<DatabaseErrorModel, QuerySnapshot<Map<String, dynamic>>>>
      getUserData(UserUidModel model);
}

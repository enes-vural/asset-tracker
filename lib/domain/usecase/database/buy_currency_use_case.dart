import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:asset_tracker/domain/entities/database/request/save_user_entity.dart';
import 'package:asset_tracker/domain/repository/database/firestore/ifirestore_repository.dart';
import 'package:asset_tracker/domain/usecase/base/base_use_case.dart';
import 'package:dartz/dartz.dart';


//TODO: Use caseler databsae use case altına toplanacak.
class DatabaseUseCase
    extends BaseUseCase<BuyCurrencyEntity, BuyCurrencyEntity> {
  final IFirestoreRepository firestoreRepository;

  DatabaseUseCase({required this.firestoreRepository});

  @override
  Future<Either<BaseErrorEntity, BuyCurrencyEntity>> call(params) async {
    return await firestoreRepository.buyCurrency(params);
  }

  Future<Either<BaseErrorEntity, bool>> deleteUserTransaction(
      UserCurrencyEntity entity) async {
    return await firestoreRepository.deleteUserTransaction(entity);
  }


  Future<Either<BaseErrorEntity, bool>> sellCurrency(
      UserCurrencyEntity entity) async {
    return await firestoreRepository.sellCurrency(entity);
  }

  Future<Either<DatabaseErrorEntity, List<AssetCodeModel>>> getAssetCodes(
      params) async {
    return await firestoreRepository.getAssetCodes();
  }

  Future<Either<DatabaseErrorEntity, UserDataEntity>> getUserData(
      UserUidEntity params) async {
    return await firestoreRepository.getUserData(params);
  }

  Future<Either<DatabaseErrorEntity, bool>> saveUserData(
      SaveUserEntity params) async {
    return await firestoreRepository.saveUser(params);
  }
}

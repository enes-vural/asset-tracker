import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/data/model/database/error/database_error_model.dart';
import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';
import 'package:asset_tracker/data/model/database/request/user_uid_model.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/data/model/database/response/user_data_model.dart';
import 'package:asset_tracker/data/model/user_currency_data_model.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/ifirestore_service.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/usar_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:asset_tracker/domain/repository/database/firestore/ifirestore_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FirestoreRepository implements IFirestoreRepository {
  final IFirestoreService firestoreService;

  const FirestoreRepository({required this.firestoreService});

  @override
  Future<Either<DatabaseErrorEntity, List<AssetCodeModel>>>
      getAssetCodes() async {
    final currencyCodeList = await firestoreService.getAssetCodes();
    //we setted our default empty error
    DatabaseErrorEntity emptyError =
        DatabaseErrorEntity(message: LocaleKeys.trade_nullAssetCodes.tr());

    return currencyCodeList.fold(
      (DatabaseErrorModel failure) {
        return Left(DatabaseErrorEntity.fromModel(failure));
      },
      (List<AssetCodeModel> success) {
        //the error statement if value was empty
        if (success.isEmpty) {
          debugPrint("Asset codes are empty ERROR: Line 27: DEVELOPER ERROR");
          return Left(emptyError);
        }

        //another cases we will return the success value
        return Right(success);
      },
    );
  }

  @override
  Future<Either<DatabaseErrorEntity, BuyCurrencyEntity>> buyCurrency(
      BuyCurrencyEntity entity) async {
    final data =
        await firestoreService.buyCurrency(BuyCurrencyModel.fromEntity(entity));

    return data.fold((failure) {
      return Left(DatabaseErrorEntity.fromModel(failure));
    }, (success) {
      return Right(BuyCurrencyEntity.fromModel(success));
    });
  }

  @override
  Future<Either<DatabaseErrorEntity, UserDataEntity>> getUserData(
      UserUidEntity model) async {
    double totalBalance = 0.00;
    UserDataModel userDataModel = UserDataModel(
        currencyList: [], uid: model.userId, balance: totalBalance);

    try {
      final userAssetsData =
          await firestoreService.getUserAssets(UserUidModel.fromEnttiy(model));

      if (userAssetsData == null || userAssetsData.isEmpty) {
        return Left(DatabaseErrorEntity(
            message: LocaleKeys.dashboard_assetDataNull.tr()));
      }

      for (var dataIndex in userAssetsData) {
        debugPrint("User assets data: ${dataIndex.toString()}");
        if (dataIndex != null) {
          userDataModel.currencyList
              .add(UserCurrencyDataModel.fromJson(dataIndex));
        }
      }

      for (var currency in userDataModel.currencyList) {
        totalBalance += currency.total;
      }
      userDataModel.balance = totalBalance;

      return Right(UserDataEntity.fromModel(userDataModel));
    } catch (e) {
      return Left(DatabaseErrorEntity(message: e.toString()));
    }
  }
}

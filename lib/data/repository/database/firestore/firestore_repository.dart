import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/data/model/database/error/database_error_model.dart';
import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';
import 'package:asset_tracker/data/model/database/request/user_uid_model.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/data/model/database/response/user_data_model.dart';
import 'package:asset_tracker/data/model/database/response/user_currency_data_model.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/ifirestore_service.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
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
        await firestoreService
        .saveTransaction(BuyCurrencyModel.fromEntity(entity));

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
        //If user has no assets, we will return empty list
        debugPrint("User assets data is empty");
        return Right(UserDataEntity(
          currencyList: [],
          userId: model.userId,
          balance: totalBalance,
        ));
      }

      for (Map<String, dynamic>? dataIndex in userAssetsData) {
        debugPrint("User assets data: ${dataIndex.toString()}");
        if (dataIndex != null) {
          userDataModel.currencyList
              .add(UserCurrencyDataModel.fromJson(dataIndex));
        }
      }

      for (var currency in userDataModel.currencyList) {
        if (currency.transactionType == TransactionTypeEnum.BUY) {

        totalBalance += currency.total;
        }
      }
      userDataModel.balance = totalBalance;

      return Right(UserDataEntity.fromModel(userDataModel));
    } catch (e) {
      return Left(DatabaseErrorEntity(message: e.toString()));
    }
  }

  @override
  Future<Either<DatabaseErrorEntity, bool>> deleteUserTransaction(
      UserCurrencyEntity entity) async {
    final UserCurrencyDataModel model =
        UserCurrencyDataModel.fromEntity(entity);

    try {
      final status = await firestoreService.deleteUserTransaction(model);
      return status.fold(
        (failure) {
          return Left(DatabaseErrorEntity.fromModel(failure));
        },
        (success) {
          debugPrint("Delete user transaction success: $success");
          return Right(success);
        },
      );
    } catch (e) {
      return Left(DatabaseErrorEntity(message: e.toString()));
    }
  }
  
  @override
  Future<Either<DatabaseErrorEntity, bool>> sellCurrency(
      UserCurrencyEntity entity) async {
    final UserCurrencyDataModel model =
        UserCurrencyDataModel.fromEntity(entity);
    try {
      final status = await firestoreService.sellCurrency(model);
      return status.fold(
        (failure) {
          return Left(DatabaseErrorEntity.fromModel(failure));
        },
        (success) {
          debugPrint("Sell user transaction success: $success");
          return Right(success);
        },
      );
    } catch (e) {
      return Left(DatabaseErrorEntity(message: e.toString()));
    }
  }
}

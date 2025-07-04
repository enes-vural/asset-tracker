import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/data/model/database/error/database_error_model.dart';
import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';
import 'package:asset_tracker/data/model/database/request/save_user_model.dart';
import 'package:asset_tracker/data/model/database/request/user_uid_model.dart';
import 'package:asset_tracker/data/model/database/response/user_data_model.dart';
import 'package:asset_tracker/data/model/database/response/user_currency_data_model.dart';
import 'package:asset_tracker/data/model/database/user_info_model.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/ifirestore_service.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/sell_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_info_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:asset_tracker/domain/entities/database/request/save_user_entity.dart';
import 'package:asset_tracker/domain/repository/database/firestore/ifirestore_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class FirestoreRepository implements IFirestoreRepository {
  final IFirestoreService firestoreService;

  const FirestoreRepository({required this.firestoreService});

  @override
  Future<Either<DatabaseErrorEntity, SaveCurrencyEntity>> buyCurrency(
      SaveCurrencyEntity entity) async {
    final data = await firestoreService
        .saveTransaction(SaveCurrencyModel.fromEntity(entity));

    return data.fold((failure) {
      return Left(DatabaseErrorEntity.fromModel(failure));
    }, (success) {
      return Right(SaveCurrencyEntity.fromModel(success));
    });
  }

  @override
  Future<Either<DatabaseErrorEntity, UserDataEntity>> getUserData(
      UserUidEntity model) async {
    double totalBalance = 0.00;
    UserDataModel userDataModel = UserDataModel(
        currencyList: [], uid: model.userId, balance: totalBalance);
    final uidEntity = UserUidModel.fromEnttiy(model);

    try {
      final userInfoData = await firestoreService.getUserInfo(uidEntity);
      final userAssetsData = await firestoreService.getUserAssets(uidEntity);

      if (userInfoData != null) {
        userDataModel.userInfoModel = UserInfoModel.fromJson(userInfoData);
      } else {
        debugPrint("User data came null ??");
      }

      if (userAssetsData == null || userAssetsData.isEmpty) {
        //If user has no assets, we will return empty list
        debugPrint("User assets data is empty");
        return Right(UserDataEntity(
          currencyList: [],
          userId: model.userId,
          balance: totalBalance,
          userInfoEntity: userDataModel.userInfoModel?.toEntity(),
        ));
      }

      for (Map<String, dynamic>? dataIndex in userAssetsData) {
        // debugPrint("User assets data: ${dataIndex.toString()}");
        if (dataIndex != null) {
          if (dataIndex.isEmpty) {
            debugPrint("User assets data is empty, skipping...");
            continue;
          }
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
      SellCurrencyEntity entity) async {
    try {
      final status = await firestoreService.sellCurrency(entity.toModel());
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

  @override
  Future<Either<DatabaseErrorEntity, bool>> saveUser(
      SaveUserEntity entity) async {
    final SaveUserModel model = SaveUserModel.fromEntity(entity);
    try {
      final response = await firestoreService.saveUser(model);
      return response.fold(
        (failure) {
          return Left(DatabaseErrorEntity.fromModel(failure));
        },
        (success) {
          debugPrint("Save user success: $success");
          return Right(success);
        },
      );
    } catch (e) {
      return Left(DatabaseErrorEntity(message: e.toString()));
    }
  }

  @override
  Future<Either<DatabaseErrorEntity, bool>> removeUser(
      UserUidEntity model) async {
    final entity = UserUidModel.fromEnttiy(model);
    final data = await firestoreService.removeUser(entity);
    return data.fold((DatabaseErrorModel failure) {
      return Left(DatabaseErrorEntity.fromModel(failure));
    }, (success) {
      debugPrint("User data has removed");
      return Right(success);
    });
  }

  @override
  Future<Either<DatabaseErrorEntity, bool>> changeUserInfo(
      UserInfoEntity infoModel) async {
    final data = await firestoreService.changeUserInfo(infoModel.toModel());

    return data.fold(
      (failure) {
        return Left(DatabaseErrorEntity.fromModel(failure));
      },
      (success) {
        return Right(success);
      },
    );
  }
}

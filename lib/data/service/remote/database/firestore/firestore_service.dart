// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/core/constants/firestore_constants.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/data/model/database/error/database_error_model.dart';
import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';
import 'package:asset_tracker/data/model/database/request/save_user_model.dart';
import 'package:asset_tracker/data/model/database/request/user_uid_model.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/data/model/database/response/user_currency_data_model.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/ifirestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final class FirestoreService implements IFirestoreService {
  final FirebaseFirestore instance;

  const FirestoreService({required this.instance});

  @override
  //eğer işlem başarılıysa verdiğimiz modeli geri döndürsün istiyorum.
  Future<Either<DatabaseErrorModel, BuyCurrencyModel>> saveTransaction(
      BuyCurrencyModel model) async {
    if (model.userId == null) {
      Left(DatabaseErrorModel(message: LocaleKeys.trade_userIdNull.tr()));
    }

    try {
      //TODO:
      //aynı tarih farklı saat alımları test edilmedi

      await instance
          .collection(FirestoreConstants.usersCollection)
          .doc(model.userId)
          .collection(FirestoreConstants.assetsCollection)
          .doc(model.currency)
          .set({"currencyName": model.currency});

      return await instance
          .collection(FirestoreConstants.usersCollection)
          .doc(model.userId)
          .collection(FirestoreConstants.assetsCollection)
          .doc(model.currency)
          .collection(model.transactionType.value.toString())
          .doc(model.date.toString())
          //TODO: check here
          .set(
            model.toFirebaseJson(),
            SetOptions(merge: true),
          )
          .then((_) {
        return Right(model);
      });
    } catch (e) {
      return Left(DatabaseErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<DatabaseErrorModel, QuerySnapshot<Map<String, dynamic>>>>
      getUserData(UserUidModel model) async {
    try {
      final data = await instance
          .collection(FirestoreConstants.usersCollection)
          .doc(model.userId)
          .collection(FirestoreConstants.assetsCollection)
          .get();
      return Right(data);
    } catch (e) {
      return Left(DatabaseErrorModel(message: e.toString()));
    }
  }

  @override
  Future<List<Map<String, dynamic>?>> getUserAssets(
    UserUidModel model,
  ) async {
    List<Map<String, dynamic>?> assetDataList = [];
    try {
      final assetPath = await _assetCollection(model).get();

      String originPath = assetPath.docs.toString();
      debugPrint(originPath.toString());

      for (var assetDoc in assetPath.docs) {
        final currencyName = assetDoc.id;

        for (final type in [
          TransactionTypeEnum.BUY.value,
          TransactionTypeEnum.SELL.value
        ]) {
          final datePath =
              _assetCollection(model).doc(currencyName).collection(type);

          List<Timestamp> dateList = [];

          final dateData = await datePath.get();

          dateData.docs.forEach((element) {
            debugPrint('[$type] ${element.data()}');
            dateList.add(element.data()['date']);
          });

          for (var date in dateList) {
            final data = await _assetCollection(model)
                .doc(currencyName)
                .collection(type)
                .doc(date.toDate().toString())
                .get();

            assetDataList.add(data.data());
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return assetDataList;
  }

  CollectionReference<Map<String, dynamic>> _assetCollection(
      UserUidModel model) {
    return instance
        .collection(FirestoreConstants.usersCollection)
        .doc(model.userId)
        .collection(FirestoreConstants.assetsCollection);
  }

  @override
  Future<Either<DatabaseErrorModel, List<AssetCodeModel>>>
      getAssetCodes() async {
    List<AssetCodeModel> assetCodeList = [];

    try {
      await instance
          .collection(FirestoreConstants.assetsCollection)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          assetCodeList.add(AssetCodeModel.fromJson(element.data()));
        });
      });

      return Right(assetCodeList);
    } catch (e) {
      debugPrint(e.toString());
      return Left(DatabaseErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<DatabaseErrorModel, bool>> deleteUserTransaction(
      UserCurrencyDataModel model) async {
    try {
      await instance
          .collection(FirestoreConstants.usersCollection)
          .doc(model.userId)
          .collection(FirestoreConstants.assetsCollection)
          .doc(model.currencyCode)
          .collection(model.transactionType.value.toString())
          .doc(model.buyDate.toDate().toString())
          .delete();
      return const Right(true);
    } catch (e) {
      debugPrint(e.toString());
      return Left(DatabaseErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<DatabaseErrorModel, bool>> sellCurrency(
      UserCurrencyDataModel model) async {
    try {
      //SELL olarak db ye kaydediyoruz
      await saveTransaction(BuyCurrencyModel.fromUserCurrencyModel(model));
      //Fakat kullanıcıdan silmek için önceki modeldeki transactionType'ı
      //BUY olarak güncelleyip silme işlemini yapıyoruz.
      //Böylece kullanıcıdan silinen işlem, db'de SELL olarak kalıyor.
      //ve BUY tarafındaki transaction u siliyoruz.
      final removeModel = model.copyWith(
        transactionType: TransactionTypeEnum.BUY,
      );
      await deleteUserTransaction(removeModel);
      return const Right(true);
    } catch (e) {
      debugPrint(e.toString());
      return Left(DatabaseErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<DatabaseErrorModel, bool>> saveUser(SaveUserModel model) async {
    try {
      await instance
          .collection(FirestoreConstants.usersCollection)
          .doc(model.uid)
          .set(model.toJson());
      return const Right(true);
    } catch (e) {
      debugPrint(e.toString());
      return Left(DatabaseErrorModel(message: e.toString()));
    }
  }
}

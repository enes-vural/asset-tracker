// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:asset_tracker/core/constants/firestore_constants.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/data/model/database/error/database_error_model.dart';
import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';
import 'package:asset_tracker/data/model/database/request/user_uid_model.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
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
  Future<Either<DatabaseErrorModel, BuyCurrencyModel>> buyCurrency(
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
          .collection(model.currency)
          .doc(model.date.toString())
          .set(model.toJson())
          .then((_) {
        return Right(model);
      });
    } catch (e) {
      return Left(DatabaseErrorModel(message: e.toString()));
    }
  }

  @override
  Future<void> sellCurrency() {
    throw UnimplementedError();
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
      final assetPath = await _assetCollection(model)
          .get();

      String originPath = assetPath.docs.toString();
      debugPrint(originPath.toString());

      for (var assetDoc in assetPath.docs) {
        final currencyName = assetDoc.id;

        final datePath =
            _assetCollection(model)
            .doc(currencyName)
            .collection(currencyName);

        List<Timestamp> dateList = [];

        final dateData = await datePath.get();

        dateData.docs.forEach((element) {
          debugPrint(element.data().toString());
          dateList.add(element.data()['date']);
        });

        for (var date in dateList) {
          final data = await _assetCollection(model)
              .doc(currencyName)
              .collection(currencyName)
              .doc(date.toDate().toString())
              .get();

          assetDataList.add(data.data());
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
}

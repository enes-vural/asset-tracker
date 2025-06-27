// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/core/constants/firestore_constants.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/data/model/database/error/database_error_model.dart';
import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';
import 'package:asset_tracker/data/model/database/request/save_user_model.dart';
import 'package:asset_tracker/data/model/database/request/sell_currency_model.dart';
import 'package:asset_tracker/data/model/database/request/user_uid_model.dart';
import 'package:asset_tracker/data/model/database/response/user_currency_data_model.dart';
import 'package:asset_tracker/data/model/database/user_info_model.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/ifirestore_service.dart';
import 'package:asset_tracker/env/envied.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final class FirestoreService implements IFirestoreService {
  final FirebaseFirestore instance;

  const FirestoreService({required this.instance});

  @override
  //eğer işlem başarılıysa verdiğimiz modeli geri döndürsün istiyorum.
  Future<Either<DatabaseErrorModel, SaveCurrencyModel>> saveTransaction(
      SaveCurrencyModel model) async {
    if (model.userId == null) {
      Left(DatabaseErrorModel(message: LocaleKeys.trade_userIdNull.tr()));
    }

    try {
      final userDoc = instance
          .collection(FirestoreConstants.usersCollection)
          .doc(model.userId);

      final assetDoc = userDoc
          .collection(FirestoreConstants.assetsCollection)
          .doc(model.currency);

      await assetDoc.set({"currencyName": model.currency});

      final collectionRef = assetDoc.collection(model.transactionType.value);

      final docRef = collectionRef.doc();
      final updatedModel = model.changeWithDocId(docId: docRef.id);

      await docRef.set(
        updatedModel.toFirebaseJson(),
        SetOptions(merge: true),
      );
      return Right(updatedModel);
    } catch (e, stackTrace) {
      debugPrint('CRASH ERROR: $e');
      debugPrint('Stack trace: $stackTrace');
      return Left(DatabaseErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<DatabaseErrorModel, bool>> changeUserInfo(
      UserInfoModel infoModel) async {
    try {
      await instance
          .collection(FirestoreConstants.usersCollection)
          .doc(infoModel.uid)
          .set(infoModel.toJson());
      return const Right(true);
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
          TransactionTypeEnum.SELL.value,
        ]) {
          final datePath =
              _assetCollection(model).doc(currencyName).collection(type);

          List<String> docList = [];

          final docIds = await datePath.get();

          docIds.docs.forEach((element) {
            debugPrint('[$type] ${element.data()}');
            docList.add(element.id);
          });

          for (var docId in docList) {
            final data = await _assetCollection(model)
                .doc(currencyName)
                .collection(type)
                .doc(docId)
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
  Future<Either<DatabaseErrorModel, bool>> deleteUserTransaction(
      UserCurrencyDataModel model) async {
    try {
      await instance
          .collection(FirestoreConstants.usersCollection)
          .doc(model.userId)
          .collection(FirestoreConstants.assetsCollection)
          .doc(model.currencyCode)
          .collection(model.transactionType.value)
          .doc(model.docId)
          .delete();
      return const Right(true);
    } catch (e) {
      debugPrint(e.toString());
      return Left(DatabaseErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserInfo(UserUidModel model) async {
    final userPath = await instance
        .collection(FirestoreConstants.usersCollection)
        .doc(model.userId)
        .get();

    return userPath.data();
  }

  @override
  Future<Either<DatabaseErrorModel, bool>> sellCurrency(
      SellCurrencyModel model) async {
    final Env env = Env();
    try {
      final userId = model.userId;
      final currency = model.currencyCode;
      final sellAmount = model.sellAmount;
      final sellPrice = model.sellPrice;

      double remaining = sellAmount;
      double totalBuyCost = 0;
      double totalAmountMatched = 0;

      final buyDocs = await instance
          .collection(FirestoreConstants.usersCollection)
          .doc(userId)
          .collection(FirestoreConstants.assetsCollection)
          .doc(currency)
          .collection(TransactionTypeEnum.BUY.value)
          .orderBy("date")
          .get();

      for (final doc in buyDocs.docs) {
        final data = doc.data();
        final double amount =
            double.tryParse(env.tryDecrypt(data["amount"].toString())) ?? 0.0;
        final double price =
            double.tryParse(env.tryDecrypt((data["price"].toString()))) ?? 0.0;

        if (remaining <= 0) break;

        if (amount <= remaining) {
          await doc.reference.delete();
          totalBuyCost += amount * price;
          totalAmountMatched += amount;
          remaining -= amount;
        } else {
          final newAmount = amount - remaining;
          await doc.reference.update({
            "amount": env.encryptText(newAmount.toString()),
            "total": env.encryptText((newAmount * price).toString()),
          });

          totalBuyCost += remaining * price;
          totalAmountMatched += remaining;
          remaining = 0;
        }
      }
      if (remaining > 0) {
        return const Left(DatabaseErrorModel(message: "Yeterli varlık yok."));
      }

      final avgBuyPrice = totalBuyCost / totalAmountMatched;
      final profit = (sellPrice - avgBuyPrice) * sellAmount;

      final sellModel = model.copyWith(
        buyPrice: avgBuyPrice,
        transactionType: TransactionTypeEnum.SELL,
        protif: profit,
        price: avgBuyPrice,
      );

      await saveTransaction(SaveCurrencyModel.fromSellCurrencyModel(sellModel));
      //Fakat kullanıcıdan silmek için önceki modeldeki transactionType'ı
      //BUY olarak güncelleyip silme işlemini yapıyoruz.
      //Böylece kullanıcıdan silinen işlem, db'de SELL olarak kalıyor.
      //ve BUY tarafındaki transaction u siliyoruz.
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

  @override
  Future<Either<DatabaseErrorModel, bool>> removeUser(
      UserUidModel model) async {
    try {
      await instance
          .collection(FirestoreConstants.usersCollection)
          .doc(model.userId)
          .delete();
      return const Right(true);
    } catch (e) {
      debugPrint(e.toString());
      return Left(DatabaseErrorModel(message: e.toString()));
    }
  }
}

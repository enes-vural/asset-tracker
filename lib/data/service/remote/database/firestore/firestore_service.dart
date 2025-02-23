import 'package:asset_tracker/data/model/database/error/database_error_model.dart';
import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/ifirestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

final class FirestoreService implements IFirestoreService {
  final FirebaseFirestore instance;

  const FirestoreService({required this.instance});

  @override
  //eğer işlem başarılıysa verdiğimiz modeli geri döndürsün istiyorum.
  Future<Either<DatabaseErrorModel, BuyCurrencyModel>> buyCurrency(
      BuyCurrencyModel model) async {
    if (model.userId == null) {
      const Left(DatabaseErrorModel(message: "User id is null"));
    }

    try {
      //arka arkaya satın alımlarda üstüne eklenmesi gerekecek bunu düzenle yoksa
      //TODO:
      //her seferinde eski değer yerine yeni bir değer oluşturacak.
      return await instance
          .collection("users")
          .doc(model.userId)
          .collection("assets")
          .doc(model.currency)
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
  Future<Either<DatabaseErrorModel, List<AssetCodeModel>>>
      getAssetCodes() async {
    List<AssetCodeModel> assetCodeList = [];

    try {
      await instance.collection("assets").get().then((value) {
        // ignore: avoid_function_literals_in_foreach_calls
        value.docs.forEach((element) {
          debugPrint(element.data().toString());
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

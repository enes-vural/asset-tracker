import 'package:asset_tracker/data/model/database/error/database_error_model.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/ifirestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

final class FirestoreService implements IFirestoreService {
  final FirebaseFirestore instance;

  const FirestoreService({required this.instance});

  @override
  Future<void> buyCurrency() {
    throw UnimplementedError();
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

import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/usar_data_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart'
    show CurrencyEntity;
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppGlobalProvider extends ChangeNotifier {
  List<AssetCodeModel> assetCodes = [];
  List<CurrencyEntity>? currencyList;
  Stream? _dataStream;

  UserDataEntity? _userData;

  updateUserData(UserDataEntity entity) {
    _userData = entity;
    notifyListeners();
  }

  listenDataStream() {
    if (_dataStream == null) return;

    _dataStream?.listen((event) {
      print("Data Stream : $event");
    });
  }

  updateSocketCurrency(Stream? newStream) {
    _dataStream = newStream;
    notifyListeners();
    _listenData();
  }

  _listenData() {
    _dataStream?.listen((event) {
      debugPrint("Data Stream : $event");
    });
  }

  Future<void> getCurrencyList(WidgetRef ref) async {
    //Future provider can be replace in here but we don't need to use it
    //already default provider can handle it.
    final result = await ref.read(getAssetCodesUseCaseProvider)(null);

    result.fold((error) {}, (success) {
      assetCodes = success;
      notifyListeners();
    });
  }
  
  UserDataEntity? get getUserData => _userData;
  Stream? get getDataStream => _dataStream;
}

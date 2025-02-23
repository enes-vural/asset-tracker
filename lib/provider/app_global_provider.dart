import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppGlobalProvider extends ChangeNotifier {
  List<AssetCodeModel> assetCodes = [];

  Future<void> getCurrencyList(WidgetRef ref) async {
    //Future provider can be replace in here but we don't need to use it
    //already default provider can handle it.
    final result = await ref.read(getAssetCodesUseCaseProvider)(null);

    result.fold((error) {}, (success) {
      assetCodes = success;
      notifyListeners();
    });
  }
}

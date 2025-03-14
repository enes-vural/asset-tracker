import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/usar_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/general/calculate_profit_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart'
    show CurrencyEntity;
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppGlobalProvider extends ChangeNotifier {
  List<AssetCodeModel> assetCodes = [];
  Stream? _dataStream;
  List<String>? _userCurrencies;
  UserDataEntity? _userData;
  double _totalProfitPercent = 0.0;
  double _totalProfit = 0.0;
  double _userBalance = 0.0;
  double _latestBalance = 0.0;

  List<CurrencyEntity>? globalAssets;

  updateUserData(UserDataEntity entity) {
    _userData = entity;
    _userData?.currencyList.forEach((element) {
      _userCurrencies?.add(element.currencyCode);
    });
    notifyListeners();
  }

  //TODO:
  //Burası da değişecek optimize değil.
  void updateSocketCurrency(Stream? newStream) {
    _dataStream = newStream;
    notifyListeners();
    _listenData();
    notifyListeners();
  }

  void _listenData() {
    //TODO:
    //optimization for avoid multi listening.
    _dataStream?.listen((event) {
      globalAssets = event;
      debugPrint("Data Stream é: $event");
      calculateProfitBalance();
      notifyListeners();
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

  CalculateProfitEntity? calculateProfitOrLoss(String currencyCode) {
    // Global ve kullanıcı verilerinde dövizleri bulma
    double totalPurchasePrice = 0.0;
    double userAmount = 0.0;

    final globalIndex = globalAssets?.firstWhere(
      (element) => element.code.toLowerCase() == currencyCode.toLowerCase(),
    );

    _userData?.currencyList.forEach((element) {
      if (element.currencyCode.toLowerCase() == currencyCode.toLowerCase()) {
        totalPurchasePrice += element.price * element.amount;
        userAmount += element.amount;
      }
    });

    // Eğer her iki döviz de bulunduysa, işlemi yapıyoruz
    if (globalIndex == null) {
      return null;
    }

    double globalPrice = double.parse(globalIndex.satis);

    double totalCurrentValue = globalPrice * userAmount;

    return CalculateProfitEntity(
      currencyCode: currencyCode,
      purchasePriceTotal: totalPurchasePrice,
      latestPriceTotal: totalCurrentValue,
    );
  }

  void calculateProfitBalance() {
    final UserDataEntity? userData = _userData;

    _dataStream?.listen((event) {
      globalAssets = event;
      notifyListeners();
    });

    List<UserCurrencyEntityModel> userCurrencyList =
        userData?.currencyList ?? [];

    double userBalance = userData?.balance ?? 0.00;
    double newBalance = userBalance;

    CurrencyEntity? currency;

    //TODO: Isolate this logic to a use case
    userCurrencyList.forEach((element) {
      try {
        currency = globalAssets?.firstWhere(
          (elementCurrency) => elementCurrency.code == element.currencyCode,
        );
      } catch (e) {
        currency = null;
      }

      if (currency?.code != null) {
        double oldPrice = element.price * element.amount;
        double newPrice = double.parse(currency!.satis) * element.amount;
        double latestPrice = newPrice - oldPrice;
        newBalance += latestPrice;
      }
    });
    _totalProfit = newBalance - userBalance;
    _totalProfitPercent = 100 - ((newBalance * 100) / userBalance);
    _latestBalance = newBalance;
    _userBalance = userBalance;

    if (userData != null) {
      updateUserData(userData.copyWith(
          profit: _totalProfitPercent, latestBalance: newBalance));
      notifyListeners();
    }
  }

  UserDataEntity? get getUserData => _userData;
  Stream? get getDataStream => _dataStream;
  List<String>? get userCurrencies => _userCurrencies;

  double get getProfit => _totalProfit;
  double get getPercentProfit => _totalProfitPercent;
  double get getUserBalance => _userBalance;
  double get getLatestBalance {
    //TODO: remove
    print(_latestBalance);
    return _latestBalance;
  }
}

import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
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

  //if failure has been occurred we will return false
  //if success we will update user data
  //and return true
  Future<bool> getLatestUserData(WidgetRef ref, UserUidEntity entity) async {
    final result = await ref.read(databaseUseCaseProvider).getUserData(entity);
    return await result.fold(
      (failure) {
        debugPrint("Error: ${failure.message}");
        return false;
      },
      (success) async {
        await updateUserData(success);
        notifyListeners();
        return true;
      },
    );
  }


  Future<void> clearData() async {
    _dataStream = null;
    _userData = null;
    _userCurrencies = [];
    globalAssets = [];
    _totalProfitPercent = 0.0;
    _totalProfit = 0.0;
    _userBalance = 0.0;
    _latestBalance = 0.0;
    notifyListeners();
  }

  updateUserData(UserDataEntity entity) {
    _userData = entity;
    _userData?.currencyList.forEach((element) {
      _userCurrencies?.add(element.currencyCode);
    });
    notifyListeners();
  }

  void updateSocketCurrency(Stream? newStream) {
    _dataStream = newStream;
    notifyListeners();
    _listenData();
    notifyListeners();
  }

  void _listenData() {
    _dataStream?.listen((event) {
      globalAssets = event;
      //debugPrint("Data Stream é: $event");
      calculateProfitBalance();
      notifyListeners();
    });
  }

  Future<void> getCurrencyList(WidgetRef ref) async {
    //Future provider can be replace in here but we don't need to use it
    //already default provider can handle it.
    final result = await ref.read(databaseUseCaseProvider).getAssetCodes(null);

    result.fold((error) {}, (success) {
      assetCodes = success;
      notifyListeners();
    });
  }

  CalculateProfitEntity? calculateProfitOrLoss(String currencyCode) {
    // Global ve kullanıcı verilerinde dövizleri bulma
    double totalPurchasePrice = 0.0;
    double userAmount = 0.0;
    CurrencyEntity? globalIndex;
    try {
      globalIndex = globalAssets?.firstWhere(
        (element) => element.code.toLowerCase() == currencyCode.toLowerCase(),
      );
    } catch (e) {
      debugPrint("Error: $e");
    }

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

    double globalPrice = double.parse(globalIndex.alis);

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

    List<UserCurrencyEntity> userCurrencyList = userData?.currencyList ?? [];

    double userBalance = userData?.balance ?? 0.00;
    double newBalance = userBalance;

    CurrencyEntity? currency;

    //TODO: Isolate this logic to a use case
    for (UserCurrencyEntity element in userCurrencyList) {
      try {
        if (element.transactionType == TransactionTypeEnum.SELL) {
          continue;
        }
        currency = globalAssets?.firstWhere(
          (globalCurrency) => globalCurrency.code == element.currencyCode,
        );
      } catch (e) {
        currency = null;
      }

      if (currency?.code != null) {
        double oldPrice = element.price * element.amount;
        double newPrice = double.parse(currency!.alis) * element.amount;
        double latestPrice = newPrice - oldPrice;
        newBalance += latestPrice;
      }
    }
    _totalProfit = newBalance - userBalance;
    _totalProfitPercent = ((newBalance * 100) / userBalance) - 100;
    _latestBalance = newBalance;
    _userBalance = userBalance;

    if (userData != null) {
      updateUserData(userData.copyWith(
          profit: _totalProfitPercent, latestBalance: newBalance));
      notifyListeners();
    }
  }

  UserDataEntity? get getUserData => _userData;
  Stream? get getDataStream => _dataStream?.asBroadcastStream();
  List<String>? get userCurrencies => _userCurrencies;

  double get getProfit => _totalProfit;
  double get getPercentProfit => _totalProfitPercent;
  double get getUserBalance => _userBalance;
  double get getLatestBalance => _latestBalance;
}

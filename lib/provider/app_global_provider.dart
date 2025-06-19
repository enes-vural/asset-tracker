import 'dart:async';

import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/core/constants/enums/socket/socket_state_enums.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/general/calculate_profit_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart'
    show CurrencyEntity;
import 'package:asset_tracker/domain/usecase/database/buy_currency_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppGlobalProvider extends ChangeNotifier {
  //default index equals zero.
  int menuNavigationIndex = 0;
  List<AssetCodeModel> assetCodes = [];
  Stream? _dataStream;
  List<String>? _userCurrencies;
  UserDataEntity? _userData;
  double _totalProfitPercent = 0.0;
  double _totalProfit = 0.0;
  double _userBalance = 0.0;
  double _latestBalance = 0.0; // Default değeri 0.0 yaptık

  bool _isCalculating = false;
  Timer? _calculationTimer;

  List<CurrencyEntity>? globalAssets;

  void changeMenuNavigationIndex(int newIndex) {
    if (menuNavigationIndex != newIndex) {
      menuNavigationIndex = newIndex;
      notifyListeners();
    }
  }

  Future<bool> getLatestUserData(WidgetRef ref, UserUidEntity entity) async {
    final result = await getIt<DatabaseUseCase>().getUserData(entity);
    return await result.fold(
      (failure) {
        debugPrint("Error: ${failure.message}");
        return false;
      },
      (success) async {
        await updateUserData(success);
        // Veri güncellendiğinde profit hesaplamayı yap
        if (globalAssets != null && globalAssets!.isNotEmpty) {
          scheduleCalculation();
          notifyListeners();
        }
        return true;
      },
    );
  }

  Future<void> clearData() async {
    _userData = null;
    _userCurrencies = [];
    _totalProfitPercent = 0.0;
    _totalProfit = 0.0;
    _userBalance = 0.0;
    _latestBalance = 0.0;
    notifyListeners();
  }

  updateUserData(UserDataEntity entity) {
    _userData = entity;
    _userBalance = entity.balance; // User balance'ı burada set et
    _userCurrencies ??= []; // Null ise boş liste oluştur
    _userCurrencies?.clear(); // Önceki verileri temizle

    _userData?.currencyList.forEach((element) {
      _userCurrencies?.add(element.currencyCode);
    });
    notifyListeners();
  }

  void updateSocketCurrency(Stream? newStream) {
    _dataStream = newStream;
    _listenData();
    notifyListeners();
  }

  void _listenData() {
    _dataStream?.listen((event) {
      globalAssets = event;
      _updateAssetCodes();
      // Hem global assets hem de user data varsa hesaplama yap
      scheduleCalculation();

      notifyListeners();
    });
  }

  void scheduleCalculation() {
    // Eğer zaten hesaplama zamanlanmışsa, önceki timer'ı iptal et
    _calculationTimer?.cancel();

    // 300ms sonra hesaplama yap (debounce)
    _calculationTimer = Timer(const Duration(milliseconds: 100), () {
      if (_canCalculateProfit()) {
        _calculateProfitBalanceInternal();
      }
    });
  }

  bool _canCalculateProfit() {
    return _userData != null &&
        globalAssets != null &&
        globalAssets!.isNotEmpty &&
        !_isCalculating;
  }

  _updateAssetCodes() {
    if (assetCodes.length ==
        int.parse(SocketActionEnum.FILTERED_ITEM_LENGTH.value)) {
      return;
    }
    globalAssets?.forEach((element) {
      assetCodes.add(AssetCodeModel(code: element.code));
    });
  }

  CalculateProfitEntity? calculateProfitOrLoss(String currencyCode) {
    double totalPurchasePrice = 0.0;
    double userAmount = 0.0;
    CurrencyEntity? globalIndex;

    try {
      globalIndex = globalAssets?.firstWhere(
        (element) => element.code.toLowerCase() == currencyCode.toLowerCase(),
      );
    } catch (e) {
      debugPrint("Error finding currency: $e");
      return null;
    }

    _userData?.currencyList.forEach((element) {
      if (element.currencyCode.toLowerCase() == currencyCode.toLowerCase()) {
        totalPurchasePrice += element.price * element.amount;
        userAmount += element.amount;
      }
    });

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

  void _calculateProfitBalanceInternal() {
    if (_isCalculating) return;

    _isCalculating = true;

    try {
      final UserDataEntity? userData = _userData;

      if (userData == null || globalAssets == null || globalAssets!.isEmpty) {
        debugPrint(
            "Cannot calculate profit: missing data - userData: ${userData != null}, globalAssets: ${globalAssets?.length ?? 0}");
        return;
      }

      List<UserCurrencyEntity> userCurrencyList = userData.currencyList;
      double userBalance = userData.balance;
      double newBalance = userBalance;

      for (UserCurrencyEntity element in userCurrencyList) {
        if (element.transactionType == TransactionTypeEnum.SELL) {
          continue;
        }

        try {
          final currency = globalAssets?.firstWhere(
            (globalCurrency) =>
                globalCurrency.code.toUpperCase() ==
                element.currencyCode.toUpperCase(),
          );

          if (currency?.code != null) {
            double oldPrice = element.price * element.amount;
            double newPrice = double.parse(currency!.alis) * element.amount;
            double latestPrice = newPrice - oldPrice;
            newBalance += latestPrice;
          }
        } catch (e) {
          debugPrint("Currency not found: ${element.currencyCode}");
          continue;
        }
      }

      _totalProfit = newBalance - userBalance;
      _totalProfitPercent =
          userBalance > 0 ? ((newBalance * 100) / userBalance) - 100 : 0.0;
      _latestBalance = newBalance;
      _userBalance = userBalance;

      debugPrint(_userBalance.toString());
      debugPrint(_latestBalance.toString());
      debugPrint(_totalProfitPercent.toString());
      debugPrint(_totalProfit.toString());

      final updatedUserData = userData.copyWith(
          profit: _totalProfitPercent, latestBalance: _latestBalance);
      _userData = updatedUserData;

      //updateUserData(updatedUserData);

      notifyListeners();
    } finally {
      _isCalculating = false;
    }
  }

  // Getter methods
  UserDataEntity? get getUserData => _userData;
  Stream? get getDataStream => _dataStream?.asBroadcastStream();
  List<String>? get userCurrencies => _userCurrencies;
  double get getProfit => _totalProfit;
  double get getPercentProfit => _totalProfitPercent;
  double get getUserBalance => _userBalance;
  double get getLatestBalance => _latestBalance;
}

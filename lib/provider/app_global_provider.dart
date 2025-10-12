import 'dart:async';
import 'dart:io';

import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/core/constants/enums/socket/socket_state_enums.dart';
import 'package:asset_tracker/core/constants/global/general_constants.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/domain/entities/database/alarm_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_info_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/general/calculate_profit_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart'
    show CurrencyEntity;
import 'package:asset_tracker/domain/usecase/database/database_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isFirstDataFetched = false;

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

  updateUserInfo(UserInfoEntity entity) {
    if (_userData?.userInfoEntity != entity) {
      _userData?.userInfoEntity = entity;
      notifyListeners();
    }
  }

  updateUserAlarm(List<AlarmEntity>? entityList) {
    _userData?.userAlarmList = entityList;
    notifyListeners();
  }

  addSingleUserAlamr(AlarmEntity entity) {
    if (_userData?.userAlarmList != null) {
      _userData?.userAlarmList?.add(entity);
    }
    notifyListeners();
  }

  updateSingleUserAlarm(AlarmEntity singleAlarm) {
    if (_userData?.userAlarmList != null) {
      final updatedList = _userData!.userAlarmList!.map((alarm) {
        if (alarm.docID == singleAlarm.docID) {
          return singleAlarm;
        }
        return alarm;
      }).toList();

      _userData?.userAlarmList = updatedList;
      notifyListeners();
    }
  }

  removeSingleAlarm(AlarmEntity singleAlarm) {
    if (_userData?.userAlarmList != null) {
      _userData?.userAlarmList!
          .removeWhere((item) => item.docID == singleAlarm.docID);
      notifyListeners();
    }
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

  void updateHomeWidget() async {
    final List<CurrencyEntity>? assets = globalAssets;

    if (assets == null) {
      debugPrint("Assets verisi null, widget güncellenemiyor.");
      return;
    }

    debugPrint("Home Widget Güncelleniyor...");

    final CurrencyEntity gramGold = assets.firstWhere(
      (asset) => asset.code == 'KULCEALTIN',
      orElse: () => CurrencyEntity.empty(),
    );
    final CurrencyEntity usd = assets.firstWhere(
      (asset) => asset.code == 'USDTRY',
      orElse: () => CurrencyEntity.empty(),
    );
    final CurrencyEntity euro = assets.firstWhere(
      (asset) => asset.code == 'EURTRY',
      orElse: () => CurrencyEntity.empty(),
    );
    final CurrencyEntity silver = assets.firstWhere(
      (asset) => asset.code == 'GUMUSTRY',
      orElse: () => CurrencyEntity.empty(),
    );

    if (Platform.isIOS) {
      // GRAM ALTIN
      await HomeWidget.saveWidgetData(
          'gramAltin_buy', gramGold.alis.toString());
      await HomeWidget.saveWidgetData(
          'gramAltin_sell', gramGold.satis.toString());
      await HomeWidget.saveWidgetData(
          'gramAltin_change', gramGold.fark.toString());

      // DOLAR
      await HomeWidget.saveWidgetData('dolar_buy', usd.alis.toString());
      await HomeWidget.saveWidgetData('dolar_sell', usd.satis.toString());
      await HomeWidget.saveWidgetData('dolar_change', usd.fark.toString());

      // EURO
      await HomeWidget.saveWidgetData('euro_buy', euro.alis.toString());
      await HomeWidget.saveWidgetData('euro_sell', euro.satis.toString());
      await HomeWidget.saveWidgetData('euro_change', euro.fark.toString());

      // GÜMÜŞ
      await HomeWidget.saveWidgetData('gumus_buy', silver.alis.toString());
      await HomeWidget.saveWidgetData('gumus_sell', silver.satis.toString());
      await HomeWidget.saveWidgetData('gumus_change', silver.fark.toString());

      // Son güncelleme saati
      DateTime parsedDate =
          DateFormat('dd-MM-yyyy HH:mm:ss').parse(gramGold.tarih);
      String formattedTime = DateFormat('HH:mm').format(parsedDate);

      await HomeWidget.saveWidgetData('lastUpdate', formattedTime);

      await HomeWidget.updateWidget(
        name: GeneralConstants.iosWidgetId,
        iOSName: GeneralConstants.iosWidgetId,
        androidName: GeneralConstants.androidWidgetId,
      );
    } else if (Platform.isAndroid) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gramAltin_buy', gramGold.alis.toString());
      await prefs.setString('gramAltin_sell', gramGold.satis.toString());
      await prefs.setString('gramAltin_change', gramGold.fark.toString());

      await prefs.setString('dolar_buy', usd.alis.toString());
      await prefs.setString('dolar_sell', usd.satis.toString());
      await prefs.setString('dolar_change', usd.fark.toString());

      await prefs.setString('euro_buy', euro.alis.toString());
      await prefs.setString('euro_sell', euro.satis.toString());
      await prefs.setString('euro_change', euro.fark.toString());

      await prefs.setString('gumus_buy', silver.alis.toString());
      await prefs.setString('gumus_sell', silver.satis.toString());
      await prefs.setString('gumus_change', silver.fark.toString());

      DateTime parsedDate =
          DateFormat('dd-MM-yyyy HH:mm:ss').parse(gramGold.tarih);
      String formattedTime = DateFormat('HH:mm').format(parsedDate);
      await prefs.setString('lastUpdate', formattedTime);

      HomeWidget.updateWidget(
          androidName: GeneralConstants.androidWidgetId,
          iOSName: GeneralConstants.iosWidgetId,
          name: GeneralConstants.iosWidgetId);
    }
  }

  void _listenData() {
    _dataStream?.listen((event) {
      globalAssets = event;
      //print(globalAssets);
      if (!isFirstDataFetched) {
        _cacheCurrencyData(globalAssets);
        updateHomeWidget();
        isFirstDataFetched = true;
      }
      notifyListeners();
      _updateAssetCodes();
      // Hem global assets hem de user data varsa hesaplama yap
      scheduleCalculation();

      notifyListeners();
    });
  }

  void _cacheCurrencyData(List<CurrencyEntity>? globalAssets) {
    // getIt<DatabaseUseCase>().cacheCurrencyList(globalAssets ?? []);
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

//Buradaki algoritma Claude'e yazdırıldı vibe coding. Şimdilik prod a aldım teker teker incelenmesi gerek.
//TODO:
  CalculateProfitEntity? calculateProfitOrLoss(String currencyCode) {
    double totalPurchasePrice = 0.0;
    double totalCurrentValue = 0.0;
    double totalBuyAmount = 0.0;
    double totalSellAmount = 0.0;
    CurrencyEntity? globalIndex;

    bool hasBuyTransactions = false;
    bool hasSellTransactions = false;

    try {
      globalIndex = globalAssets?.firstWhere(
        (element) => element.code.toLowerCase() == currencyCode.toLowerCase(),
      );
    } catch (e) {
      debugPrint("Error finding currency: $e");
      return null;
    }

    if (globalIndex == null) {
      return null;
    }

    // 1. Alım işlemlerini kontrol et
    _userData?.currencyList.forEach((element) {
      if (element.currencyCode.toLowerCase() == currencyCode.toLowerCase()) {
        hasBuyTransactions = true;
        totalBuyAmount += element.amount;
      }
    });

    // 2. Satım işlemlerini kontrol et
    _userData?.soldCurrencyList?.forEach((element) {
      if (element.currencyCode.toLowerCase() == currencyCode.toLowerCase()) {
        hasSellTransactions = true;
        totalSellAmount += element.amount;
      }
    });

    // 3. Purchase Price Hesaplama
    if (hasBuyTransactions) {
      // Kullanıcıda alım işlemi varsa, satım işlemlerini pas geç
      // Sadece alım işlemlerinin toplam fiyatını hesapla
      _userData?.currencyList.forEach((element) {
        if (element.currencyCode.toLowerCase() == currencyCode.toLowerCase()) {
          totalPurchasePrice += element.price * element.amount;
        }
      });
    } else if (hasSellTransactions && !hasBuyTransactions) {
      // Kullanıcıda sadece satım işlemi varsa
      // Satım işlemlerinin oldPrice'ını (ortalama alış fiyatı) kullan
      _userData?.soldCurrencyList?.forEach((element) {
        if (element.currencyCode.toLowerCase() == currencyCode.toLowerCase()) {
          totalPurchasePrice += (element.oldPrice ?? 0.0) * element.amount;
        }
      });
    }

    // 4. Current Value Hesaplama
    if (hasSellTransactions) {
      // Satım işlemleri varsa bunları current value'ye ekle
      _userData?.soldCurrencyList?.forEach((element) {
        if (element.currencyCode.toLowerCase() == currencyCode.toLowerCase()) {
          totalCurrentValue += element.price * element.amount;
        }
      });
    }

    if (hasBuyTransactions) {
      // Alım işlemleri varsa bunların güncel değerini globalIndex'ten al
      double globalPrice = double.parse(globalIndex.alis);
      totalCurrentValue += globalPrice * totalBuyAmount;
    }

    return CalculateProfitEntity(
      currencyCode: currencyCode,
      purchasePriceTotal: totalPurchasePrice,
      latestPriceTotal: totalCurrentValue,
    );
  }

  Map<String, double>? _getSelectedCurrencyPrice(String currencyCode) {
    if (globalAssets == null || globalAssets!.isEmpty) {
      debugPrint("Global assets is null or empty");
      return null;
    }

    try {
      final currency = globalAssets?.firstWhere(
        (element) => element.code.toLowerCase() == currencyCode.toLowerCase(),
      );

      if (currency == null) {
        debugPrint("Currency not found: $currencyCode");
        return null;
      }

      return {
        'alis': double.parse(currency.alis),
        'satis': double.parse(currency.satis),
      };
    } catch (e) {
      debugPrint("Error getting currency price for $currencyCode: $e");
      return null;
    }
  }

// Alternatif olarak sadece alış fiyatını döndüren fonksiyon
  double? getSelectedCurrencyBuyPrice(String currencyCode) {
    final prices = _getSelectedCurrencyPrice(currencyCode);
    return prices?['alis'];
  }

// Alternatif olarak sadece satış fiyatını döndüren fonksiyon
  double? getSelectedCurrencySellPrice(String currencyCode) {
    final prices = _getSelectedCurrencyPrice(currencyCode);
    return prices?['satis'];
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

      // debugPrint(_userBalance.toString());
      // debugPrint(_latestBalance.toString());
      // debugPrint(_totalProfitPercent.toString());
      // debugPrint(_totalProfit.toString());

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

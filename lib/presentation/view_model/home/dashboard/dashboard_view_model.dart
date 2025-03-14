import 'package:asset_tracker/domain/entities/database/enttiy/usar_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/general/calculate_profit_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardViewModel extends ChangeNotifier {
  UserDataEntity? _userData;
  List<UserCurrencyEntityModel>? _transactions;

  Map<String, List<UserCurrencyEntityModel>> _filteredTransactions = {};

  void showAssetsAsStatistic(WidgetRef ref) {
    _userData = ref.read(appGlobalProvider.notifier).getUserData;
    _transactions = _userData?.currencyList;

    _filteredTransactions.clear(); // Önce temizle

    _transactions?.forEach((element) {
      if (_filteredTransactions.containsKey(element.currencyCode)) {
        _filteredTransactions[element.currencyCode]
            ?.add(element); // Varsa, listeyi güncelle
      } else {
        _filteredTransactions[element.currencyCode] = [
          element
        ]; // Yoksa yeni bir liste ekle
      }
      notifyListeners();
    });
  }

  CalculateProfitEntity? calculateSelectedCurrencyTotalAmount(
      WidgetRef ref, String currencyCode) {
    return ref
        .watch(appGlobalProvider.notifier)
        .calculateProfitOrLoss(currencyCode);
  }

  Map<String, List<UserCurrencyEntityModel>>? get filteredTransactions =>
      _filteredTransactions;
}

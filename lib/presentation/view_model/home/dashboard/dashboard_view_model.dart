import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/sell_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/general/calculate_profit_entity.dart';
import 'package:asset_tracker/domain/usecase/database/buy_currency_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardViewModel extends ChangeNotifier {
  UserDataEntity? _userData;
  List<UserCurrencyEntity>? _transactions;

  bool canPop = true;

  void changePopState(bool state) {
    canPop = state;
    notifyListeners();
  }

  final Map<String, List<UserCurrencyEntity>> _filteredTransactions = {};

  void showAssetsAsStatistic(WidgetRef ref) {
    _userData = ref.read(appGlobalProvider.notifier).getUserData;
    _transactions =
        (_userData?.currencyList ?? []) + (_userData?.soldCurrencyList ?? []);

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
  

  Future<void> sellAsset(WidgetRef ref, UserCurrencyEntity transaction) async {
    changePopState(false);

    CalculateProfitEntity? latestState =
        calculateSelectedCurrencyTotalAmount(ref, transaction.currencyCode);

    final latestCurrencyData = transaction.copyWith(
        total: (latestState?.latestPriceTotal),
        price: ((latestState?.latestPriceTotal ?? 0) / transaction.amount),
        transactionType: TransactionTypeEnum.SELL);

    final sellCurrencyEntity = SellCurrencyEntity(
      buyPrice: latestCurrencyData.price,
      sellAmount: latestCurrencyData.amount,
      currencyCode: latestCurrencyData.currencyCode,
      sellPrice: latestState?.latestPriceTotal ?? 0,
      date: DateTime.now(),
      userId: latestCurrencyData.userId,
    );

    final status =
        await getIt<DatabaseUseCase>().sellCurrency(sellCurrencyEntity);
    await status.fold((error) async {
      // Handle error
    }, (success) async {
      if (success) {
        debugPrint("Transaction sold successfully");
        await _updateLatestUserInfo(transaction, ref);
      }
    });
    changePopState(true);
  }

  Future<void> _updateLatestUserInfo(
      UserCurrencyEntity transaction, WidgetRef ref) async {
    _transactions?.remove(transaction);
    _filteredTransactions[transaction.currencyCode]
        ?.remove(transaction); // Remove from filtered transactions
    await ref
        .read(appGlobalProvider.notifier)
        .getLatestUserData(ref, UserUidEntity(userId: transaction.userId));
    notifyListeners();
  }

  Future<void> removeTransaction(
      WidgetRef ref, UserCurrencyEntity transaction) async {
    changePopState(false);
    final status =
        await getIt<DatabaseUseCase>().deleteUserTransaction(transaction);
    await status.fold((error) async {
      // Handle error
    }, (success) async {
      if (success) {
        await _updateLatestUserInfo(transaction, ref);
      }
    });
    changePopState(true);
  }

  CalculateProfitEntity? calculateSelectedCurrencyTotalAmount(
      WidgetRef ref, String currencyCode) {
    return ref
        .watch(appGlobalProvider.notifier)
        .calculateProfitOrLoss(currencyCode);
  }

  Map<String, List<UserCurrencyEntity>>? get filteredTransactions =>
      _filteredTransactions;
}

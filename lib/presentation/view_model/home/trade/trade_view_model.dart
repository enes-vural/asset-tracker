import 'package:asset_tracker/core/config/constants/global/key/fom_keys.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TradeViewModel extends ChangeNotifier {
  String? selectedCurrency;

  DateTime? selectedDate;

  void changeSelectedDate(DateTime? newDate) {
    selectedDate = newDate;
    notifyListeners();
  }

  void changeSelectedCurrency(String? newValue) {
    if (newValue == selectedCurrency) {
      return;
    }
    selectedCurrency = newValue;
    notifyListeners();
  }

  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<AssetCodeModel> getCurrencyList(WidgetRef ref) =>
      ref.read(appGlobalProvider.notifier).assetCodes;

  Future<void> buyCurrency(
      {required WidgetRef ref, required BuildContext context}) async {
    final amount = double.parse(amountController.text);
    final price = double.parse(priceController.text);
    final currency = selectedCurrency;
    final date = selectedDate;
    final currentUserId = ref.read(authGlobalProvider).currentUserId;

    if (!GlobalFormKeys.tradeFormKey.currentState!.validate()) {
      EasySnackBar.show(context, "Please fill all fields");
      return;
    }

    if (currency == null || date == null) {
      EasySnackBar.show(context, "Please select a currency and date");
      return;
    }

    if (currentUserId == null) {
      EasySnackBar.show(context, "Please re-login to buy currency");
      return;
    }

    final BuyCurrencyEntity buyCurrencyEntity = BuyCurrencyEntity(
      amount: amount,
      price: price,
      currency: currency,
      date: date,
      userId: currentUserId,
    );

    final request =
        await ref.read(buyCurrencyUseCaseProvider)(buyCurrencyEntity);

    request.fold((failure) {
      EasySnackBar.show(context, failure.message);
    }, (success) {
      EasySnackBar.show(context,
          "Currency ${success.currency} bought ${success.amount} successfully per ${success.price}");
      amountController.clear();
      priceController.clear();
    });
  }
}

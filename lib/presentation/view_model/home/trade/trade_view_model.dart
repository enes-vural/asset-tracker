// ignore_for_file: unused_local_variable

import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/core/constants/global/key/fom_keys.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TradeViewModel extends ChangeNotifier {
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String? selectedCurrency;
  DateTime? selectedDate;

  bool canPop = true;

  void changePopState(bool state) {
    if (canPop != state) {
      canPop = state;
      notifyListeners();
    }
  }

  void changeSelectedDate(DateTime? newDate) {
    selectedDate = newDate;
    notifyListeners();
  }

  void changeSelectedCurrency(String? newValue) {
    if (newValue == null || newValue == "") {
      return;
    }
    if (newValue == selectedCurrency) {
      return;
    }
    selectedCurrency = newValue;
    notifyListeners();
  }

//tamam
  List<AssetCodeModel> getCurrencyList(WidgetRef ref) =>
      ref.read(appGlobalProvider.notifier).assetCodes;

  Future<void> buyCurrency(
      {required WidgetRef ref, required BuildContext context}) async {
    if (!GlobalFormKeys.tradeFormKey.currentState!.validate()) {
      EasySnackBar.show(context, LocaleKeys.trade_fillAllFields.tr());
      return;
    }

    changePopState(false);
    final amount = double.tryParse(amountController.text) ?? 0.0;
    final price = double.tryParse(priceController.text) ?? 0.0;
    final currency = selectedCurrency;
    final date = selectedDate;
    final currentUserId = ref.read(authGlobalProvider).getCurrentUserId;

    if (currency == null) {
      EasySnackBar.show(context, LocaleKeys.trade_invalidType.tr());
      return;
    }

    if (date == null) {
      EasySnackBar.show(context, LocaleKeys.trade_invalidDate.tr());
      return;
    }

    if (currentUserId == null) {
      EasySnackBar.show(context, LocaleKeys.trade_relogin.tr());
      return;
    }

    final BuyCurrencyEntity buyCurrencyEntity = BuyCurrencyEntity(
        amount: amount,
        price: price,
        currency: currency,
        date: date,
        userId: currentUserId,
        transactionType: TransactionTypeEnum.BUY);

    //Save to Offline Actions
    String? offlineKey =
        await ref.read(cacheUseCaseProvider).saveOfflineAction(Tuple2(
              OfflineActionType.BUY_ASSET,
              buyCurrencyEntity,
            ));

    final request =
        await ref.read(buyCurrencyUseCaseProvider)(buyCurrencyEntity);

    request.fold((failure) {
      EasySnackBar.show(context, failure.message);
    }, (success) async {
      //TODO: Test edilecek
      ref.read(cacheUseCaseProvider).removeOfflineAction(offlineKey);
      EasySnackBar.show(
        context,
        LocaleKeys.trade_success.tr(
          namedArgs: {
            DefaultLocalStrings.currency: success.currency,
            DefaultLocalStrings.amount: success.amount.toString(),
            DefaultLocalStrings.price: success.price.toString()
          },
        ),
      );
      UserDataEntity? userData =
          ref.watch(appGlobalProvider.notifier).getUserData;

      //alım satım durumlaında bizden kaynaklı olan veya olmayan bir durumdan
      //dolayı işlem başarılı zannedilirse ve kullanıcı bilgileri güncellenmezse
      //direkt olarak son bakiye hesaplamalarını provider üzerinden yönetiyoruz
      //ama bu durumlara karşıda bir güvenlik önlemi olarak kullanıcı bilgilerini
      //her işlem sonrasında database den çekerek güncelliyoruz.
      final latestUserData = await ref
          .read(getUserDataUseCaseProvider)
          .call(UserUidEntity(userId: currentUserId));

      latestUserData.fold(
        //TODO: buraya dispose engeli canpop gelecek
        (l) {},
        (newUserData) {
          userData = newUserData;
          //TODO: bug recall after dispoe
          ref
              .read(appGlobalProvider.notifier)
              .updateUserData(newUserData.copyWith());
        },
      );

      amountController.clear();
      priceController.clear();
      notifyListeners();
      changePopState(true);
    });
  }
}

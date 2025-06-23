// ignore_for_file: unused_local_variable
import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/string_extension.dart';
import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/core/constants/enums/widgets/app_pages_enum.dart';
import 'package:asset_tracker/core/constants/enums/widgets/trade_type_enum.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/sell_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/general/calculate_profit_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/domain/usecase/cache/cache_use_case.dart';
import 'package:asset_tracker/domain/usecase/database/database_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TradeViewModel extends ChangeNotifier {
  TextEditingController amountController = TextEditingController();
  TextEditingController priceTotalController = TextEditingController();
  TextEditingController priceUnitController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TradeType currentTradeType = TradeType.buy;

  String? selectedCurrency;
  DateTime? selectedDate;

  bool canPop = true;

  void toggleTradeType(WidgetRef ref, TradeType type) {
    currentTradeType = type;
    getPriceSelectedCurrency(ref);
    notifyListeners();
  }

  void routeTradeView(
      {required bool isBuy, required WidgetRef ref, required String currency}) {
    currentTradeType = isBuy ? TradeType.buy : TradeType.sell;
    selectedCurrency = currency;
    amountController.text = "1";
    ref
        .read(appGlobalProvider)
        .changeMenuNavigationIndex(AppPagesEnum.TRADE.pageIndex);
  }

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

  void getPriceSelectedCurrency(WidgetRef ref) {
    if (selectedCurrency == null) {
      return;
    }
    final rawAssets = ref.read(appGlobalProvider.notifier).globalAssets;
    List<CurrencyWidgetEntity> assets = [];
    rawAssets?.forEach((value) {
      assets.add(CurrencyWidgetEntity.fromCurrency(value));
    });

    //name e göre sıralamak doğru bir yol değil. Şimdilik kalsın sonrasında map yapısı ile dropdown daki labellar ile 
    //code ları eşleştirerek unique bir sisteme gidilmesi daha doğru olur. Aynı isimdeki assetler de hata fırlatabilir örn: "N/A"
    //TODO:
    CurrencyWidgetEntity? selectedAssetCode;
    try {
      selectedAssetCode = assets.firstWhere(
        (element) => element.name == selectedCurrency,
      );
} catch (e) {
      selectedAssetCode = null;
    }

    if (selectedAssetCode != null) {
      // Debug için ekle
      debugPrint('selectedAssetCode.satis: ${selectedAssetCode.entity.satis}');
      debugPrint(
          'selectedAssetCode.satis type: ${selectedAssetCode.entity.satis.runtimeType}');
      debugPrint(
          'Current priceUnitController.text: ${priceUnitController.text}');

      priceTotalController.text = ((double.tryParse(amountController.text) ??
                  0.0) *
              //if trade type is buy automatically get sell price else fetch buy price
              (double.tryParse(currentTradeType == TradeType.buy
                      ? selectedAssetCode.entity.satis.removeTurkishLiraSign()
                      : selectedAssetCode.entity.alis
                          .removeTurkishLiraSign()) ??
                  0.0))
          .toString();
      //selectedAssetCode veya currency.entity yapmamızın nedeni
      //widget entity nin para biriminin '.' ve ',' ler ile basamak ayırması.
      //direkt ülke cinsi veya '.', ',' parse ile uğraşmamak için WidgetEntity içindeki
      //entity i kullanarak . ve vilgüre çevirilmeden önceki double halini kullandım.
      final newUnitValue = currentTradeType == TradeType.buy
          ? selectedAssetCode.entity.satis.removeTurkishLiraSign()
          : selectedAssetCode.entity.alis.removeTurkishLiraSign();
      debugPrint('New unit value: $newUnitValue');

      priceUnitController.text = newUnitValue;
      debugPrint(
          'After assignment priceUnitController.text: ${priceUnitController.text}');
    } else {
      priceUnitController.clear();
      priceTotalController.clear();
    }
  }

  CalculateProfitEntity? calculateSelectedCurrencyTotalAmount(
      WidgetRef ref, String currencyCode) {
    return ref
        .watch(appGlobalProvider.notifier)
        .calculateProfitOrLoss(currencyCode);
  }

  Future<void> _updateLatestUserInfo(String userId, WidgetRef ref) async {
    await ref
        .read(appGlobalProvider.notifier)
        .getLatestUserData(ref, UserUidEntity(userId: userId));
    notifyListeners();
  }

  Future<void> sellCurrency({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    changePopState(false);

    if (selectedCurrency == null) {
      EasySnackBar.show(context, "Birim Seçiniz");
      return;
    }
    if (selectedDate == null) {
      return;
    }

    final sellCurrencyEntity = SellCurrencyEntity(
      sellAmount: double.tryParse(amountController.text) ?? 0.0,
      currencyCode: getCurrencyCodeFromLabel(selectedCurrency)!,
      sellPrice: double.tryParse(priceUnitController.text) ?? 0.0,
      date: selectedDate!,
      userId: ref.read(authGlobalProvider).getCurrentUserId.toString(),
    );

    final status =
        await getIt<DatabaseUseCase>().sellCurrency(sellCurrencyEntity);
    await status.fold((error) async {
      EasySnackBar.show(context, error.message.toString());
    }, (success) async {
      if (success) {
        debugPrint("Transaction sold successfully");
        await _updateLatestUserInfo(sellCurrencyEntity.userId, ref);
        ref
            .read(appGlobalProvider)
            .changeMenuNavigationIndex(AppPagesEnum.WALLET.pageIndex);
      }
    });
    changePopState(true);
  }

  List<AssetCodeModel> getCurrencyList(WidgetRef ref) =>
      ref.read(appGlobalProvider.notifier).assetCodes;

  Future<void> buyCurrency(
      {required WidgetRef ref, required BuildContext context}) async {
    changePopState(false);
    final amount = double.tryParse(amountController.text) ?? 0.0;
    final price = double.tryParse(priceUnitController.text) ?? 0.0;
    //Localize edilmiş title dan seçilen değerin Code u alındı.
    //Database e asset'in code u olarak kaydedilebilsin diye.
    final currency = getCurrencyCodeFromLabel(selectedCurrency);
    // setCurrencyLabel(currencyCode)
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

    final SaveCurrencyEntity saveCurrencyEntity = SaveCurrencyEntity(null,
        amount: amount,
        price: price,
        currency: currency,
        date: date,
        userId: currentUserId,
        transactionType: TransactionTypeEnum.BUY);

    //Save to Offline Actions
    String? offlineKey = await getIt<CacheUseCase>().saveOfflineAction(Tuple2(
      OfflineActionType.BUY_ASSET,
      saveCurrencyEntity,
    ));
    final request = await getIt<DatabaseUseCase>().call(saveCurrencyEntity);

    await request.fold((failure) {
      EasySnackBar.show(context, failure.message);
    }, (SaveCurrencyEntity success) async {
      getIt<CacheUseCase>().removeOfflineAction(offlineKey);
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

      //alım satım durumlaında bizden kaynaklı olan veya olmayan bir durumdan
      //dolayı işlem başarılı zannedilirse ve kullanıcı bilgileri güncellenmezse
      //direkt olarak son bakiye hesaplamalarını provider üzerinden yönetiyoruz
      //ama bu durumlara karşıda bir güvenlik önlemi olarak kullanıcı bilgilerini
      //her işlem sonrasında database den çekerek güncelliyoruz.
      if (success.userId == null) {
        EasySnackBar.show(context, "Bir Hata Oluştu");
        debugPrint("Line: 171 SaveCurrencyEntity userID is null");
        return;
      }

      await ref
          .read(appGlobalProvider)
          .getLatestUserData(ref, UserUidEntity(userId: success.userId!));

      amountController.clear();
      priceUnitController.clear();
      priceTotalController.clear();
      dateController.clear();
      changeSelectedDate(null);
      changeSelectedCurrency(null);
      notifyListeners();
    });
    changePopState(true);
    ref
        .read(appGlobalProvider)
        .changeMenuNavigationIndex(AppPagesEnum.WALLET.pageIndex);
  }
}

import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/data/model/database/response/asset_code_model.dart';
import 'package:asset_tracker/domain/entities/database/alarm_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/domain/usecase/database/database_use_case.dart';
import 'package:asset_tracker/domain/usecase/messaging/messaging_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

enum AlarmType { PRICE, PERCENT }

enum AlarmCondition { UP, DOWN }

enum AlarmOrderType { BUY, SELL }

class AlarmViewModel extends ChangeNotifier {
  TextEditingController valueController = TextEditingController();
  late TabController tabController;
  AlarmType selectedAlarmType = AlarmType.PRICE;
  AlarmCondition selectedCondition = AlarmCondition.UP;
  AlarmOrderType selectedOrderType = AlarmOrderType.BUY;

  String selectedCurrency = "";
  DateTime? selectedDate;
  double? _selectedCurrencyPrice = 0;
  double? _selectedCurrencyPercent = 0;

  bool canPop = true;

  void toggleTypes(dynamic type, WidgetRef ref) {
    if (type is AlarmType) {
      selectedAlarmType = type;
      if (selectedAlarmType == AlarmType.PERCENT) {
        _selectedCurrencyPercent = 5.0;
        valueController.text = "5";
      }
    } else if (type is AlarmCondition) {
      selectedCondition = type;
    } else if (type is AlarmOrderType) {
      selectedOrderType = type;
    }
    changePriceValue(ref);
    notifyListeners();
  }

  void changePriceValue(WidgetRef ref) {
    if (selectedAlarmType == AlarmType.PRICE) {
      _selectedCurrencyPrice = getPriceSelectedCurrency(ref);
      if (_selectedCurrencyPrice != null) {
        valueController.text = _selectedCurrencyPrice.toString();
      }
    }
    if (selectedAlarmType == AlarmType.PERCENT) {
      // valueController.text = "5";
      // _selectedCurrencyPercent = 5;
    }

    debugPrint(_selectedCurrencyPrice.toString());
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

  void changeFormText(String value) {
    if (selectedAlarmType == AlarmType.PRICE) {
      _selectedCurrencyPrice = double.tryParse(value);
    } else {
      _selectedCurrencyPercent = double.tryParse(value);
    }
    notifyListeners();
  }

  Future<void> saveAlarm(BuildContext context, WidgetRef ref) async {
    if (selectedCurrency == null || selectedCurrency == "") {
      EasySnackBar.show(
          context, LocaleKeys.alarm_snackbar_alarm_select_asset.tr());
      return;
    }
    if (valueController.text == "" ||
        double.tryParse(valueController.text) == null) {
      EasySnackBar.show(
          context, LocaleKeys.alarm_snackbar_alarm_enter_target_price.tr());
      return;
    }
    final String? currencyCode = getCurrencyCodeFromLabel(selectedCurrency);

    if (currencyCode == null || currencyCode == "") {
      return;
    }
    double? targetValue;
    if (selectedAlarmType == AlarmType.PRICE) {
      targetValue = _selectedCurrencyPrice;
    } else {
      targetValue = _selectedCurrencyPercent;
    }
    if (targetValue == null) {
      return;
    }
    String? userId = ref.read(authGlobalProvider).getCurrentUserId;

    if (userId == null) return;

    final priceWhenCreated = selectedOrderType == AlarmOrderType.BUY
        ? ref.read(appGlobalProvider).getSelectedCurrencyBuyPrice(currencyCode)
        : ref
            .read(appGlobalProvider)
            .getSelectedCurrencySellPrice(currencyCode);

    if (priceWhenCreated == null) {
      if (context.mounted) {
        EasySnackBar.show(
            context, LocaleKeys.alarm_snackbar_alarm_error_occurred.tr());
      }
      return;
    }

    if (selectedCondition == AlarmCondition.UP &&
        priceWhenCreated > targetValue) {
      EasySnackBar.show(context,
          LocaleKeys.alarm_snackbar_alarm_target_higher_than_current.tr(),
          isError: true);
      return;
    } else if (selectedCondition == AlarmCondition.DOWN &&
        priceWhenCreated < targetValue) {
      EasySnackBar.show(context,
          LocaleKeys.alarm_snackbar_alarm_target_lower_than_current.tr(),
          isError: true);
      return;
    }

    final bool isPermitted =
        await _handleNotificationToken(context, ref, userId);

    if (!isPermitted) return;

    changePopState(false);

    final alarmEntity = AlarmEntity(
      currencyCode: currencyCode,
      direction: selectedCondition,
      isTriggered: false,
      mode: selectedAlarmType,
      targetValue: targetValue,
      type: selectedOrderType,
      userID: userId,
      priceWhenCreated: priceWhenCreated,
      createTime: DateTime.now(),
    );

    final result = await getIt<DatabaseUseCase>().saveUserAlarm(alarmEntity);

    result.fold(
      (failure) {
        changePopState(true);
        debugPrint(failure.message);
        EasySnackBar.show(
            context, LocaleKeys.alarm_snackbar_alarm_created_error.tr());
        ref.read(appGlobalProvider).removeSingleAlarm(alarmEntity);
      },
      (success) async {
        changePopState(true);
        // final data = await getIt<DatabaseUseCase>()
        // .getUserAlarms(UserUidEntity(userId: userId));
        // ref.read(appGlobalProvider).updateUserAlarm(data);
        // ref.read(appGlobalProvider).updateSingleUserAlarm(alarmEntity);
        ref.read(appGlobalProvider).addSingleUserAlamr(alarmEntity);
        // EasySnackBar.show(context, "Alarm başarıyla kuruldu");
        if (context.mounted) {
          EasySnackBar.show(
              context, LocaleKeys.alarm_snackbar_alarm_created_success.tr());
        }
        tabController.index = 1;
      },
    );
  }

  Future<bool> _handleNotificationToken(
      BuildContext context, WidgetRef ref, String userId) async {
    // 1. Permission kontrolü
    final isAuthorized =
        await getIt<NotificationUseCase>().isPermissionAuthorized();
    if (!isAuthorized) {
      if (context.mounted) {
        EasySnackBar.show(context,
            "Alarm özelliğini kullanmak için bildirimlere izin vermeniz gerekiyor.",
            // LocaleKeys.notification_permission_required
            //     .tr(), // "Bildirimleri görmek için notification izni verin"
            isError: true);
      }
      return false;
    }

    // 2. Mevcut token kontrolü
    String? currentToken = ref.read(authGlobalProvider).notificationToken;

    // 3. Token yoksa yeni token al
    if (currentToken == null) {
      currentToken = await getIt<NotificationUseCase>().getUserToken();
      if (currentToken == null) {
        if (context.mounted) {
          EasySnackBar.show(context, "Bildirimlere İzin vermeniz gerekiyor",
              //LocaleKeys.notification_token_error
              //    .tr(), // "Bildirim token'ı alınamadı"
              isError: true);
        }
        return false;
      }

      // 4. Token'ı provider'da güncelle
      ref.read(authGlobalProvider).updateFcmToken(currentToken);
    }

    // 5. Token'ı database'e kaydet
    try {
      await getIt<DatabaseUseCase>()
          .saveUserToken(UserUidEntity(userId: userId), currentToken);
      return true;
    } catch (e) {
      debugPrint('Token save error: $e');
      if (context.mounted) {
        EasySnackBar.show(context, "HATA ",
            //LocaleKeys.notification_token_save_error
            //.tr(), // "Bildirim ayarları kaydedilemedi"
            isError: true);
      }
      return false;
    }
  }

  double? getPriceSelectedCurrency(WidgetRef ref) {
    if (selectedCurrency == null || selectedCurrency == "") {
      return null;
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

      if (selectedAlarmType == AlarmType.PRICE) {
        if (selectedOrderType == AlarmOrderType.BUY) {
          valueController.text = selectedAssetCode.entity.alis;
          _selectedCurrencyPrice =
              double.tryParse(selectedAssetCode.entity.alis);
          notifyListeners();
          return double.tryParse(selectedAssetCode.entity.alis);
        } else {
          valueController.text = selectedAssetCode.entity.satis;
          _selectedCurrencyPrice =
              double.tryParse(selectedAssetCode.entity.satis);
          notifyListeners();
          return double.tryParse(selectedAssetCode.entity.satis);
        }
      }
      // debugPrint(
      //     'Current priceUnitController.text: ${priceUnitController.text}');

      // priceTotalController.text = ((double.tryParse(amountController.text) ??
      //             0.0) *
      //         //if trade type is buy automatically get sell price else fetch buy price
      //         (double.tryParse(currentTradeType == TradeType.buy
      //                 ? selectedAssetCode.entity.satis.removeTurkishLiraSign()
      //                 : selectedAssetCode.entity.alis
      //                     .removeTurkishLiraSign()) ??
      //             0.0))
      //     .toString();
      // //selectedAssetCode veya currency.entity yapmamızın nedeni
      // //widget entity nin para biriminin '.' ve ',' ler ile basamak ayırması.
      // //direkt ülke cinsi veya '.', ',' parse ile uğraşmamak için WidgetEntity içindeki
      // //entity i kullanarak . ve vilgüre çevirilmeden önceki double halini kullandım.
      // final newUnitValue = currentTradeType == TradeType.buy
      //     ? selectedAssetCode.entity.satis.removeTurkishLiraSign()
      //     : selectedAssetCode.entity.alis.removeTurkishLiraSign();
      // debugPrint('New unit value: $newUnitValue');

      // priceUnitController.text = newUnitValue;
      // debugPrint(
      //     'After assignment priceUnitController.text: ${priceUnitController.text}');
    } else {}
    return null;
  }

  List<AssetCodeModel> getCurrencyList(WidgetRef ref) =>
      ref.read(appGlobalProvider.notifier).assetCodes;

  double get selectedCurrencyPrice => _selectedCurrencyPrice ?? 0.0;

  double get selectedCurrencyPercent => _selectedCurrencyPercent ?? 0.0;

  Future<bool> shouldShowNotificationCard() async {
    if (!Platform.isIOS && !Platform.isAndroid) {
      return false;
    }
    final isAuthroized =
        await getIt<NotificationUseCase>().isPermissionAuthorized();

    return !isAuthroized;
  }
}

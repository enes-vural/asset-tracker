import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/extension/asset_extension.dart';
import 'package:easy_localization/easy_localization.dart';

mixin GetCurrencyIconMixin {
  String getCurrencyIcon(String name) {
    bool currencyContains(String value) {
      return name.toLowerCase().contains(value.toLowerCase());
    }

    if (currencyContains(LocaleKeys.home_searchItems_gold.tr())) {
      return DefaultLocalStrings.goldCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_chf.tr())) {
      return DefaultLocalStrings.audCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_aud.tr())) {
      return DefaultLocalStrings.audCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_xau.tr())) {
      return DefaultLocalStrings.xauCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_sek.tr()) ||
        currencyContains(LocaleKeys.home_searchItems_dkk.tr())) {
      return DefaultLocalStrings.sekCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_nok.tr())) {
      return DefaultLocalStrings.nokCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_jpy.tr())) {
      return DefaultLocalStrings.jpyCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_silver.tr()) ||
        currencyContains(LocaleKeys.home_searchItems_xag.tr())) {
      return DefaultLocalStrings.silverCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_xpt.tr())) {
      return DefaultLocalStrings.xptCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_sar.tr())) {
      return DefaultLocalStrings.sarCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_gbp.tr())) {
      return DefaultLocalStrings.gbpCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_cad.tr())) {
      return DefaultLocalStrings.cadCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_usd.tr())) {
      return DefaultLocalStrings.usdCoin.toCurrencyPng();
    } else if (currencyContains(LocaleKeys.home_searchItems_eur.tr())) {
      return DefaultLocalStrings.euroCoin.toCurrencyPng();
    } else {
      return DefaultLocalStrings.defaultCoin.toCurrencyPng();
    }
  }
}

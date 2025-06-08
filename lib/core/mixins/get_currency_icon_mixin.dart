import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/extension/asset_extension.dart';
import 'package:easy_localization/easy_localization.dart';

mixin GetCurrencyIconMixin {
  static final Map<String, String> _currencyIconMap = {
    // Gold currencies (must be checked first due to ATA exception)
    DefaultLocalStrings.ataCode: DefaultLocalStrings.ataGoldCoin,
    DefaultLocalStrings.chfCode: DefaultLocalStrings.chfCoin,
    DefaultLocalStrings.audCode: DefaultLocalStrings.audCoin,
    DefaultLocalStrings.dkkCode: DefaultLocalStrings.dkkCoin,
    DefaultLocalStrings.sekCode: DefaultLocalStrings.sekCoin,
    DefaultLocalStrings.nokCode: DefaultLocalStrings.nokCoin,
    DefaultLocalStrings.jpyCode: DefaultLocalStrings.jpyCoin,
    DefaultLocalStrings.sarCode: DefaultLocalStrings.sarCoin,
    DefaultLocalStrings.gbpCode: DefaultLocalStrings.gbpCoin,
    DefaultLocalStrings.cadCode: DefaultLocalStrings.cadCoin,
    DefaultLocalStrings.usdCode: DefaultLocalStrings.usdCoin,
    DefaultLocalStrings.eurCode: DefaultLocalStrings.euroCoin,
  };

  static final List<String> _goldKeywords = [
    DefaultLocalStrings.goldCode,
    DefaultLocalStrings.caratKeyword,
    DefaultLocalStrings.gremseKeyword,
    DefaultLocalStrings.singleKeyword,
    DefaultLocalStrings.newKeyword,
    DefaultLocalStrings.oldKeyword,
  ];

  static final List<String> _silverKeywords = [DefaultLocalStrings.silverCode];

  String getCurrencyIcon(String name) {
    final upperName = name.toUpperCase();

    if (_containsKeyword(upperName, [DefaultLocalStrings.ataCode])) {
      return DefaultLocalStrings.ataGoldCoin.toCurrencyPng();
    }
    
    if (_containsAnyKeyword(upperName, _goldKeywords) &&
        !_containsKeyword(upperName, [DefaultLocalStrings.ataCode])) {
      return DefaultLocalStrings.goldCoin.toCurrencyPng();
    }

    if (_containsKeyword(upperName, [LocaleKeys.home_searchItems_xau.tr()])) {
      return DefaultLocalStrings.xauCoin.toCurrencyPng();
    }

    if (_containsAnyKeyword(upperName, _silverKeywords) ||
        _containsKeyword(upperName, [LocaleKeys.home_searchItems_xag.tr()])) {
      return DefaultLocalStrings.silverCoin.toCurrencyPng();
    }

    if (_containsKeyword(upperName, [LocaleKeys.home_searchItems_xpt.tr()])) {
      return DefaultLocalStrings.xptCoin.toCurrencyPng();
    }

    for (final entry in _currencyIconMap.entries) {
      if (_containsKeyword(upperName, [entry.key])) {
        return entry.value.toCurrencyPng();
      }
    }

    return DefaultLocalStrings.defaultCoin.toCurrencyPng();
  }
  
  bool _containsKeyword(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword.toUpperCase()));
  }

  bool _containsAnyKeyword(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword.toUpperCase()));
  }
}

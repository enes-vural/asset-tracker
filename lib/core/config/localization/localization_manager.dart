import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationManager {
  //static list type ına uysun diye static olarak verdim dısaridan '_' cagirilamiyor
  static const _trLocale = Locale('tr');
  static const _enLocale = Locale('en');

  static final LocalizationManager _instance = LocalizationManager._init();

  factory LocalizationManager() {
    return _instance;
  }

  LocalizationManager._init();

  static List<Locale> supportedTranslations = [
    _trLocale,
    _enLocale,
  ];

  static const fallBackLocale = _enLocale;

  Locale locale(BuildContext context) => context.locale;

  List<LocalizationsDelegate<dynamic>> delegates(BuildContext context) =>
      context.localizationDelegates;

  List<Locale> supportedLocales(BuildContext context) =>
      context.supportedLocales;

  Future<void> changeLanguage(BuildContext context) async => await context
      .setLocale(context.locale == _trLocale ? _enLocale : _trLocale);
      
  String getCurrentLanguage(BuildContext context) {
    return context.locale.languageCode;
  }

  // Alternatif: Daha ayrıntılı dil bilgisi için
  String getCurrentLanguageDisplay(BuildContext context) {
    switch (context.locale.languageCode) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      default:
        return context.locale.languageCode;
    }
  }

}

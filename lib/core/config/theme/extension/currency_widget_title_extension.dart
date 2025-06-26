import 'package:easy_localization/easy_localization.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';

String setCurrencyLabel(String currencyCode) {
  String newTitle = currencyCode.toLowerCase().getCurrencyTitle();
  return newTitle;
}

String? getCurrencyCodeFromLabel(String? value) {
  if (value == null) return null;

  // Reverse map'ten direkt lookup yap
  return _getReverseCurrencyMap()[value];
}

// Ham LocaleKeys map'i
final Map<String, String> _currencyTitleMap = {
  "ata5_yeni": LocaleKeys.home_widget_ata5_yeni,
  "ata5_eski": LocaleKeys.home_widget_ata5_eski,
  "gremese_yeni": LocaleKeys.home_widget_gremese_yeni,
  "gremese_eski": LocaleKeys.home_widget_gremese_eski,
  "ayar14": LocaleKeys.home_widget_ayar14,
  "gumustry": LocaleKeys.home_widget_gumustry,
  "gumususd": LocaleKeys.home_widget_gumususd,
  "audusd": LocaleKeys.home_widget_audusd,
  "gbpusd": LocaleKeys.home_widget_gbpusd,
  "platin": LocaleKeys.home_widget_platin,
  "paladyum": LocaleKeys.home_widget_paladyum,
  "usdjpy": LocaleKeys.home_widget_usdjpy,
  "usdchf": LocaleKeys.home_widget_usdchf,
  "usdcad": LocaleKeys.home_widget_usdcad,
  "eurusd": LocaleKeys.home_widget_eurusd,
  "usdsar": LocaleKeys.home_widget_usdsar,
  "noktry": LocaleKeys.home_widget_noktry,
  "audtry": LocaleKeys.home_widget_audtry,
  "altin": LocaleKeys.home_widget_altin,
  "usdpure": LocaleKeys.home_widget_usdpure,
  "usdtry": LocaleKeys.home_widget_usdtry,
  "ons": LocaleKeys.home_widget_ons,
  "eurtry": LocaleKeys.home_widget_eurtry,
  "usdkg": LocaleKeys.home_widget_usdkg,
  "eurkg": LocaleKeys.home_widget_eurkg,
  "ayar22": LocaleKeys.home_widget_ayar22,
  "gbptry": LocaleKeys.home_widget_gbptry,
  "chftry": LocaleKeys.home_widget_chftry,
  "kulcealtin": LocaleKeys.home_widget_kulcealtin,
  "xauxag": LocaleKeys.home_widget_xauxag,
  "ceyrek_yeni": LocaleKeys.home_widget_ceyrek_yeni,
  "cadtry": LocaleKeys.home_widget_cadtry,
  "ceyrek_eski": LocaleKeys.home_widget_ceyrek_eski,
  "sartry": LocaleKeys.home_widget_sartry,
  "yarim_yeni": LocaleKeys.home_widget_yarim_yeni,
  "yarim_eski": LocaleKeys.home_widget_yarim_eski,
  "jpytry": LocaleKeys.home_widget_jpytry,
  "tek_yeni": LocaleKeys.home_widget_tek_yeni,
  "tek_eski": LocaleKeys.home_widget_tek_eski,
  "ata_yeni": LocaleKeys.home_widget_ata_yeni,
  "ata_eski": LocaleKeys.home_widget_ata_eski,
  "dkktry": LocaleKeys.home_widget_dkktry,
  "xauusd": LocaleKeys.home_widget_xauusd,
  "xagusd": LocaleKeys.home_widget_xagusd,
  "xptusd": LocaleKeys.home_widget_xptusd,
  "xpdusd": LocaleKeys.home_widget_xpdusd,
  "plntry": LocaleKeys.home_widget_plntry,
  "huftry": LocaleKeys.home_widget_huftry,
  "sektry": LocaleKeys.home_widget_sektry,
  "zartry": LocaleKeys.home_widget_zartry,
  "gramaltin": LocaleKeys.home_widget_gramaltin,
};

// Lazy initialization ile reverse map
Map<String, String>? _reverseCurrencyMapCache;

Map<String, String> _getReverseCurrencyMap() {
  if (_reverseCurrencyMapCache == null) {
    _reverseCurrencyMapCache = {};
    _currencyTitleMap.forEach((key, value) {
      _reverseCurrencyMapCache![value.tr()] = key;
    });
  }
  return _reverseCurrencyMapCache!;
}

// Dil değiştiğinde cache'i temizle
void clearCurrencyMapCache() {
  _reverseCurrencyMapCache = null;
}

extension GetCurrencyTitle on String {
  String getCurrencyTitle() {
    return _currencyTitleMap[this]?.tr() ?? "Bulunamadı";
  }
}

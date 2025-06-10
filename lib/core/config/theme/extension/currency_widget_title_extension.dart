import 'package:easy_localization/easy_localization.dart';

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';

String setCurrencyLabel(String currencyCode) {
  String newTitle = currencyCode.toLowerCase().getCurrencyTitle();
  //burası gereksiz zaten switch case default ta N/A döndürecek
  return newTitle; // Return this if no match is found in the map
}

//Aynı isimde bir asset bulunamayacak. Kodda 
String? getCurrencyCodeFromLabel(String? value) {
  return _currencyTitleMap.entries
      .firstWhere(
        (entry) => entry.value == value,
        orElse: () => const MapEntry('', ''),
      )
      .key;
}

final Map<String, String> _currencyTitleMap = {
  "ata5_yeni": LocaleKeys.home_widget_ata5_yeni.tr(),
  "ata5_eski": LocaleKeys.home_widget_ata5_eski.tr(),
  "gremese_yeni": LocaleKeys.home_widget_gremese_yeni.tr(),
  "gremese_eski": LocaleKeys.home_widget_gremese_eski.tr(),
  "ayar14": LocaleKeys.home_widget_ayar14.tr(),
  "gumustry": LocaleKeys.home_widget_gumustry.tr(),
  "gumususd": LocaleKeys.home_widget_gumususd.tr(),
  "audusd": LocaleKeys.home_widget_audusd.tr(),
  "gbpusd": LocaleKeys.home_widget_gbpusd.tr(),
  "platin": LocaleKeys.home_widget_platin.tr(),
  "paladyum": LocaleKeys.home_widget_paladyum.tr(),
  "usdjpy": LocaleKeys.home_widget_usdjpy.tr(),
  "usdchf": LocaleKeys.home_widget_usdchf.tr(),
  "usdcad": LocaleKeys.home_widget_usdcad.tr(),
  "eurusd": LocaleKeys.home_widget_eurusd.tr(),
  "usdsar": LocaleKeys.home_widget_usdsar.tr(),
  "noktry": LocaleKeys.home_widget_noktry.tr(),
  "audtry": LocaleKeys.home_widget_audtry.tr(),
  "altin": LocaleKeys.home_widget_altin.tr(),
  //"altın": LocaleKeys.home_widget_altin.tr(),
  "usdpure": LocaleKeys.home_widget_usdpure.tr(),
  "usdtry": LocaleKeys.home_widget_usdtry.tr(),
  "ons": LocaleKeys.home_widget_ons.tr(),
  "eurtry": LocaleKeys.home_widget_eurtry.tr(),
  "usdkg": LocaleKeys.home_widget_usdkg.tr(),
  "eurkg": LocaleKeys.home_widget_eurkg.tr(),
  "ayar22": LocaleKeys.home_widget_ayar22.tr(),
  "gbptry": LocaleKeys.home_widget_gbptry.tr(),
  "chftry": LocaleKeys.home_widget_chftry.tr(),
  "kulcealtin": LocaleKeys.home_widget_kulcealtin.tr(),
  "xauxag": LocaleKeys.home_widget_xauxag.tr(),
  "ceyrek_yeni": LocaleKeys.home_widget_ceyrek_yeni.tr(),
  "cadtry": LocaleKeys.home_widget_cadtry.tr(),
  "ceyrek_eski": LocaleKeys.home_widget_ceyrek_eski.tr(),
  "sartry": LocaleKeys.home_widget_sartry.tr(),
  "yarim_yeni": LocaleKeys.home_widget_yarim_yeni.tr(),
  "yarim_eski": LocaleKeys.home_widget_yarim_eski.tr(),
  "jpytry": LocaleKeys.home_widget_jpytry.tr(),
  "tek_yeni": LocaleKeys.home_widget_tek_yeni.tr(),
  "tek_eski": LocaleKeys.home_widget_tek_eski.tr(),
  "ata_yeni": LocaleKeys.home_widget_ata_yeni.tr(),
  "ata_eski": LocaleKeys.home_widget_ata_eski.tr(),
  "dkktry": LocaleKeys.home_widget_dkktry.tr(),
  "xauusd": LocaleKeys.home_widget_xauusd.tr(),
  "xagusd": LocaleKeys.home_widget_xagusd.tr(),
  "xptusd": LocaleKeys.home_widget_xptusd.tr(),
  "xpdusd": LocaleKeys.home_widget_xpdusd.tr(),
  "plntry": LocaleKeys.home_widget_plntry.tr(),
  "huftry": LocaleKeys.home_widget_huftry.tr(),
  "sektry": LocaleKeys.home_widget_sektry.tr(),
  "zartry": LocaleKeys.home_widget_zartry.tr(),
  "gramaltin": LocaleKeys.home_widget_gramaltin.tr(),
};


extension GetCurrencyTitle on String {
  String getCurrencyTitle() {
    return _currencyTitleMap[this] ?? "Bulunamadı";
  }
}

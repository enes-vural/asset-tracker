import 'package:easy_localization/easy_localization.dart';

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';


String setCurrencyLabel(String currencyCode) {
  String newTitle = currencyTypeMap[currencyCode]?.getCurrencyTitle() ?? "N/A";
  //burası gereksiz zaten switch case default ta N/A döndürecek
  return newTitle; // Return this if no match is found in the map
}

Map<String, String> currencyTypeMap = {
  "ATA5_YENI": "ata5_yeni",
  "ATA5_ESKI": "ata5_eski",
  "GREMESE_YENI": "gremese_yeni",
  "GREMESE_ESKI": "gremese_eski",
  "AYAR14": "ayar14",
  "GUMUSTRY": "gumustry",
  "XAGUSD": "xagusd",
  "GUMUSUSD": "gumususd",
  "AUDUSD": "audusd",
  "GBPUSD": "gbpusd",
  "XPTUSD": "xptusd",
  "XPDUSD": "xpdusd",
  "PLATIN": "platin",
  "PALADYUM": "paladyum",
  "USDJPY": "usdjpy",
  "USDCHF": "usdchf",
  "USDCAD": "usdcad",
  "EURUSD": "eurusd",
  "USDSAR": "usdsar",
  "NOKTRY": "noktry",
  "AUDTRY": "audtry",
  "ALTIN": "altin",
  "USDPURE": "usdpure",
  "USDTRY": "usdtry",
  "ONS": "ons",
  "EURTRY": "eurtry",
  "USDKG": "usdkg",
  "EURKG": "eurkg",
  "AYAR22": "ayar22",
  "GBPTRY": "gbptry",
  "CHFTRY": "chftry",
  "KULCEALTIN": "kulcealtin",
  "XAUXAG": "xauxag",
  "CEYREK_YENI": "ceyrek_yeni",
  "CADTRY": "cadtry",
  "CEYREK_ESKI": "ceyrek_eski",
  "SARTRY": "sartry",
  "YARIM_YENI": "yarim_yeni",
  "YARIM_ESKI": "yarim_eski",
  "JPYTRY": "jpytry",
  "TEK_YENI": "tek_yeni",
  "TEK_ESKI": "tek_eski",
  "SEKTRY": "sektry",
  "ATA_YENI": "ata_yeni",
  "DKKTRY": "dkktry",
  "XAUUSD": "xauusd",
  "PLNTRY": "plntry",
  "HUFTRY": "huftry",
  "ZARTRY": "zartry"
};


extension GetCurrencyTitle on String {
  String getCurrencyTitle() {
    switch (this) {
      case "ata5_yeni":
        return LocaleKeys.home_widget_ata5_yeni.tr();
      case "ata5_eski":
        return LocaleKeys.home_widget_ata5_eski.tr();
      case "gremese_yeni":
        return LocaleKeys.home_widget_gremese_yeni.tr();
      case "gremese_eski":
        return LocaleKeys.home_widget_gremese_eski.tr();
      case "ayar14":
        return LocaleKeys.home_widget_ayar14.tr();
      case "gumustry":
        return LocaleKeys.home_widget_gumustry.tr();
      case "gumususd":
        return LocaleKeys.home_widget_gumususd.tr();
      case "audusd":
        return LocaleKeys.home_widget_audusd.tr();
      case "gbpusd":
        return LocaleKeys.home_widget_gbpusd.tr();
      case "platin":
        return LocaleKeys.home_widget_platin.tr();
      case "paladyum":
        return LocaleKeys.home_widget_paladyum.tr();
      case "usdjpy":
        return LocaleKeys.home_widget_usdjpy.tr();
      case "usdchf":
        return LocaleKeys.home_widget_usdchf.tr();
      case "usdcad":
        return LocaleKeys.home_widget_usdcad.tr();
      case "eurusd":
        return LocaleKeys.home_widget_eurusd.tr();
      case "usdsar":
        return LocaleKeys.home_widget_usdsar.tr();
      case "noktry":
        return LocaleKeys.home_widget_noktry.tr();
      case "audtry":
        return LocaleKeys.home_widget_audtry.tr();
      case "altin":
        return LocaleKeys.home_widget_altin.tr();
      case "usdpure":
        return LocaleKeys.home_widget_usdpure.tr();
      case "usdtry":
        return LocaleKeys.home_widget_usdtry.tr();
      case "ons":
        return LocaleKeys.home_widget_ons.tr();
      case "eurtry":
        return LocaleKeys.home_widget_eurtry.tr();
      case "usdkg":
        return LocaleKeys.home_widget_usdkg.tr();
      case "eurkg":
        return LocaleKeys.home_widget_eurkg.tr();
      case "ayar22":
        return LocaleKeys.home_widget_ayar22.tr();
      case "gbptry":
        return LocaleKeys.home_widget_gbptry.tr();
      case "chftry":
        return LocaleKeys.home_widget_chftry.tr();
      case "kulcealtin":
        return LocaleKeys.home_widget_kulcealtin.tr();
      case "xauxag":
        return LocaleKeys.home_widget_xauxag.tr();
      case "ceyrek_yeni":
        return LocaleKeys.home_widget_ceyrek_yeni.tr();
      case "cadtry":
        return LocaleKeys.home_widget_cadtry.tr();
      case "ceyrek_eski":
        return LocaleKeys.home_widget_ceyrek_eski.tr();
      case "sartry":
        return LocaleKeys.home_widget_sartry.tr();
      case "yarim_yeni":
        return LocaleKeys.home_widget_yarim_yeni.tr();
      case "yarim_eski":
        return LocaleKeys.home_widget_yarim_eski.tr();
      case "jpytry":
        return LocaleKeys.home_widget_jpytry.tr();
      case "tek_yeni":
        return LocaleKeys.home_widget_tek_yeni.tr();
      case "tek_eski":
        return LocaleKeys.home_widget_tek_eski.tr();
      case "ata_yeni":
        return LocaleKeys.home_widget_ata_yeni.tr();
      case "dkktry":
        return LocaleKeys.home_widget_dkktry.tr();
      case "xauusd":
        return LocaleKeys.home_widget_xauusd.tr();
      case "xagusd":
        return LocaleKeys.home_widget_xagusd.tr();
      case "xptusd":
        return LocaleKeys.home_widget_xptusd.tr();
      case "xpdusd":
        return LocaleKeys.home_widget_xpdusd.tr();
      case "plntry":
        return LocaleKeys.home_widget_plntry.tr();
      case "huftry":
        return LocaleKeys.home_widget_huftry.tr();
      case "sektry":
        return LocaleKeys.home_widget_sektry.tr();
      case "zartry":
        return LocaleKeys.home_widget_zartry.tr();
      default:
        return "Unknown Currency";
    }
  }
}

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/extension/asset_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/data/model/web/direction_model.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:easy_localization/easy_localization.dart';

class CurrencyWidgetEntity {
  // final String name;
  String name;
  String code;
  String alis;
  String satis;
  Direction dir;
  final CurrencyEntity entity;
  //final kullanılmayan yerlerden dolayı const eklenmedi
  CurrencyWidgetEntity({
    required this.name,
    required this.code,
    required this.alis,
    required this.satis,
    required this.entity,
    required this.dir,
  });

  factory CurrencyWidgetEntity.fromCurrency(CurrencyEntity entity) {
    final String label = setCurrencyLabel(entity.code);
    return CurrencyWidgetEntity(
      name: label,
      code: entity.code,
      alis: entity.alis,
      // 8825.25956 tarzındaki satış değerlerini => 8825.25 şeklinde düzenlemek için
      satis: entity.satis.contains('.')
          ? entity.satis.length - entity.satis.indexOf('.') > 3
              ? entity.satis.substring(0, entity.satis.indexOf('.') + 3) +
                  _currenyType(entity.code)
              : entity.satis + _currenyType(entity.code)
          : entity.satis + _currenyType(entity.code),
      entity: entity,
      dir: entity.dir,
    );
  }

  getCurrencyIcon() {
    if (_currencyContains(LocaleKeys.home_searchItems_gold.tr())) {
      return "gold_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_chf.tr())) {
      return "chf_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_aud.tr())) {
      return "aud_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_xau.tr())) {
      return "xau_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_sek.tr()) ||
        _currencyContains(LocaleKeys.home_searchItems_dkk.tr())) {
      return "sek_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_nok.tr())) {
      return "nok_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_jpy.tr())) {
      return "jpy_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_silver.tr()) ||
        _currencyContains(LocaleKeys.home_searchItems_xag.tr())) {
      return "silver_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_xpt.tr())) {
      return "xpt_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_sar.tr())) {
      return "sar_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_gbp.tr())) {
      return "gbp_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_cad.tr())) {
      return "cad_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_usd.tr())) {
      return "usd_coin".toCurrencyPng();
    } else if (_currencyContains(LocaleKeys.home_searchItems_eur.tr())) {
      return "euro_coin".toCurrencyPng();
    } else {
      return "default_coin".toCurrencyPng();
     
    }
  }

  bool _currencyContains(String value) {
    return name.toLowerCase().contains(value.toLowerCase());
  }

  static String _currenyType(String code) {
    return code.contains(LocaleKeys.home_searchItems_usd.tr())
        ? "\t\$"
        : code.contains(LocaleKeys.home_searchItems_eur.tr())
            ? "\t€"
            : "\t₺";
  }
}

enum CurrencyDirectionEnum {
  UP('up'),
  DOWN('down'),
  NONE('none');

  final String value;
  const CurrencyDirectionEnum(this.value);
}

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

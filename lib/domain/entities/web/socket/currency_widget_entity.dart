import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/data/model/web/direction_model.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:easy_localization/easy_localization.dart';

class CurrencyWidgetEntity {
  String name;
  String code;
  String alis;
  String satis;
  Direction dir;
  final CurrencyEntity entity;

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
      alis: _formatCurrency(entity.alis, entity.code),
      satis: _formatCurrency(entity.satis, entity.code),
      entity: entity,
      dir: entity.dir,
    );
  }

  /// Para birimini formatlar: 1234567.89 -> 1.234.567,89 ₺
  static String _formatCurrency(String value, String code) {
    try {
      // String'i double'a çevir
      double numValue = double.parse(value);

      // NumberFormat ile formatla
      final formatter = NumberFormat('#,##0.00', 'tr_TR');
      String formattedValue = formatter.format(numValue);

      // Türkçe formatı: virgülü nokta ile değiştir (binlik ayırıcı için)
      // Ve ondalık ayırıcıyı virgül yap
      formattedValue = formattedValue.replaceAll(',', '|'); // Geçici
      formattedValue = formattedValue.replaceAll('.', ','); // Ondalık ayırıcı
      formattedValue = formattedValue.replaceAll('|', '.'); // Binlik ayırıcı

      return formattedValue + _currencyType(code);
    } catch (e) {
      // Hata durumunda orijinal değeri döndür
      return value + _currencyType(code);
    }
  }

  /// Para birimi sembolünü döndürür
  static String _currencyType(String code) {
    if (code.contains(LocaleKeys.home_searchItems_usd.tr())) {
      return "\t\$";
    } else if (code.contains(LocaleKeys.home_searchItems_eur.tr())) {
      return "\t€";
    } else {
      return "\t₺";
    }
  }

  /// Alternatif manuel formatlama methodu (NumberFormat kullanmak istemezseniz)
  static String _formatCurrencyManual(String value, String code) {
    try {
      double numValue = double.parse(value);

      // Tam kısmı ve ondalık kısmı ayır
      List<String> parts = numValue.toStringAsFixed(2).split('.');
      String integerPart = parts[0];
      String decimalPart = parts[1];

      // Binlik ayırıcıları ekle
      String formattedInteger = '';
      for (int i = 0; i < integerPart.length; i++) {
        if (i > 0 && (integerPart.length - i) % 3 == 0) {
          formattedInteger += '.';
        }
        formattedInteger += integerPart[i];
      }
      
      // Sonucu birleştir: 1.234.567,89 formatında
      return '$formattedInteger,$decimalPart${_currencyType(code)}';
    } catch (e) {
      return value + _currencyType(code);
    }
  }
}

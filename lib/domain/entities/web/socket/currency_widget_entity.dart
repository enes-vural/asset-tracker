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

      return formattedValue + _currencyType(code);
    } catch (e) {
      // Hata durumunda orijinal değeri döndür
      return value + _currencyType(code);
    }
  }

  /// Para birimi sembolünü döndürür
  static String _currencyType(String code) {
    //Buradaki eski conditionlar kaldırıldı. 
    //DÖviz fonu özelliğinde geri eklenecek
    return "\t₺";
    
  }
}

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
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

  static String _currenyType(String code) {
    if (code.contains(LocaleKeys.home_searchItems_usd.tr())) {
      return "\t\$";
    } else if (code.contains(LocaleKeys.home_searchItems_eur.tr())) {
      return "\t€";
    } else {
      return "\t₺";
    }
  }
}

enum CurrencyDirectionEnum {
  UP('up'),
  DOWN('down'),
  NONE('none');

  final String value;
  const CurrencyDirectionEnum(this.value);
}

import 'package:easy_localization/easy_localization.dart';

extension NumberFormatting on double {
  String toNumberWithTurkishFormat() {
    final format =
        NumberFormat('#,##0.00', 'tr_TR'); // Türk formatı için yerel ayar
    return format
        .format(this)
        .replaceAll(',', '_')
        .replaceAll('.', ',')
        .replaceAll('_', '.'); // Değişim yapmak için geçici karakter kullanımı
  }
}

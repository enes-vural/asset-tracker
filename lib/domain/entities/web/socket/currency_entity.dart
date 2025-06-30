// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:asset_tracker/data/model/web/currency_model.dart';
import 'package:asset_tracker/data/model/web/direction_model.dart';

class CurrencyEntity {
  final String code;
  final String alis;
  final String tarih;
  final String satis;
  final Direction dir;
  final String dusuk;
  final String yuksek;
  final String kapanis;

  const CurrencyEntity({
    required this.code,
    required this.alis,
    required this.satis,
    required this.tarih,
    required this.dir,
    required this.dusuk,
    required this.yuksek,
    required this.kapanis,
  });

  factory CurrencyEntity.fromModel(CurrencyModel model) {
    return CurrencyEntity(
        code: model.code,
        alis: model.alis,
        tarih: model.tarih,
        dir: model.dir,
        satis: model.satis,
        dusuk: model.dusuk,
        yuksek: model.yuksek,
        kapanis: model.kapanis);
  }

  CurrencyEntity copyWith({
    String? code,
    String? alis,
    String? tarih,
    Direction? dir,
    String? satis,
    String? dusuk,
    String? yuksek,
    String? kapanis,
  }) {
    return CurrencyEntity(
      code: code ?? this.code,
      alis: alis ?? this.alis,
      tarih: tarih ?? this.tarih,
      satis: satis ?? this.satis,
      dir: dir ?? this.dir,
      dusuk: dusuk ?? this.dusuk,
      yuksek: yuksek ?? this.yuksek,
      kapanis: kapanis ?? this.kapanis,
    );
  }

  // Hash kodu hesaplama
  String get hash => '$code-$alis-$satis-'.hashCode.toString();

  double get fark {
    try {
      final double kapanisValue = double.parse(kapanis);
      final double satisValue = double.parse(satis);
      return ((satisValue - kapanisValue) / kapanisValue) * 100;
    } catch (e) {
      return 0.0;
    }
  }
}

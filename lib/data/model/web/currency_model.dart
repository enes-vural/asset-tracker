import 'package:asset_tracker/data/model/web/direction_model.dart';

class CurrencyModel {
  final String code;
  final String alis;
  final String satis;
  final String tarih;
  final Direction dir;
  final String dusuk;
  final String yuksek;
  final String kapanis;

  CurrencyModel({
    required this.code,
    required this.alis,
    required this.satis,
    required this.tarih,
    required this.dir,
    required this.dusuk,
    required this.yuksek,
    required this.kapanis,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    //print("ENES\n\n");
    // debugPrint(json.toString());
    return CurrencyModel(
      code: json['code'].toString(),
      alis: json['alis'].toString(),
      satis: json['satis'].toString(),
      tarih: json['tarih'].toString(),
      dir: Direction.fromJson(json),
      dusuk: json['dusuk'].toString(),
      yuksek: json['yuksek'].toString(),
      kapanis: json['kapanis'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'alis': alis,
      'satis': satis,
      'tarih': tarih,
      'dir': dir.toJson(),
      'dusuk': dusuk,
      'yuksek': yuksek,
      'kapanis': kapanis,
    };
  }
}

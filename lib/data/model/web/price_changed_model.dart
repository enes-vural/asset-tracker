import 'package:asset_tracker/data/model/web/meta_model.dart';
import 'package:flutter/material.dart';
import 'currency_model.dart';

class PriceChangedDataModel {
  final List<CurrencyModel> data;
  final Meta meta;

  PriceChangedDataModel({
    required this.data,
    required this.meta,
  });

  // JSON verisini modele çevirmek için
  factory PriceChangedDataModel.fromJson(Map<String, dynamic> json) {
    return PriceChangedDataModel(
      data: ((json['data'] as Map<String, dynamic>).values.toList())
          .map((item) => CurrencyModel.fromJson(item))
          .toList(), //[data]
      meta: Meta.fromJson(json['meta']),
    );
  }

  // Yeni gelen verileri mevcut verilerle güncellemek için
  PriceChangedDataModel updateData(Map<String, dynamic> newJson) {
    Map<String, dynamic> updatedData = Map.from(newJson);

    // Yalnızca değişen verileri güncelle
    for (int i = 0; i < data.length; i++) {
      debugPrint(data.map((item) => item.toJson()).toList().toString());
      if (data[i].toJson() != updatedData['data'][i]) {
        debugPrint("Different value");
        updatedData['data'][i] =
            newJson['data'][i]; // Currency değişti, güncelle
      }
    }

    return PriceChangedDataModel(
      data: (updatedData['data'] as List)
          .map((item) => CurrencyModel.fromJson(item))
          .toList(),
      meta: meta,
    );
  }
}

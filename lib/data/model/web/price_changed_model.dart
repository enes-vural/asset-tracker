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


}

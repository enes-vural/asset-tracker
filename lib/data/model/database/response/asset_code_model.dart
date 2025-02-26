import 'package:flutter/material.dart' show immutable;

@immutable
final class AssetCodeModel {
  final String code;

  const AssetCodeModel({required this.code});

  factory AssetCodeModel.fromJson(Map<String, dynamic> json) {
    return AssetCodeModel(
      code: json['code'] ?? 'N/A',
    );
  }
}

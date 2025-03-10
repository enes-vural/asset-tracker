import 'package:cloud_firestore/cloud_firestore.dart';

final class UserCurrencyDataModel {
  final double amount;
  final String currencyCode;
  final Timestamp buyDate;
  final double price;
  final double total;

  UserCurrencyDataModel(
      {required this.amount,
      required this.currencyCode,
      required this.buyDate,
      required this.price,
      required this.total});

  factory UserCurrencyDataModel.fromJson(Map<String, dynamic> json) {
    return UserCurrencyDataModel(
      amount: json['amount'] ?? 0.0,
      currencyCode: json['currency'] ?? 'N/A',
      buyDate: json['date'] ?? Timestamp.now(),
      price: json['price'] ?? 0.0,
      total: json['total'] ?? 0.0,
    );
  }
}

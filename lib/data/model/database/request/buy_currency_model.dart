import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final class BuyCurrencyModel {
  final double amount;
  final double price;
  final String currency;
  final DateTime date;
  final String? userId;
  double get total => amount * price;

  const BuyCurrencyModel({
    required this.amount,
    required this.price,
    required this.currency,
    required this.date,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': FieldValue.increment(amount),
      'price': FieldValue.increment(price),
      'currency': currency,
      'date': date,
      'userId': userId,
      'total': FieldValue.increment(total),
    };
  }

  factory BuyCurrencyModel.fromEntity(BuyCurrencyEntity entity) {
    return BuyCurrencyModel(
      amount: entity.amount,
      price: entity.price,
      currency: entity.currency,
      date: entity.date,
      userId: entity.userId,
    );
  }
}

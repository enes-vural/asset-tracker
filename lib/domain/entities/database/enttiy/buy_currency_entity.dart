import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';

final class BuyCurrencyEntity {
  final double amount;
  final double price;
  final String currency;
  final DateTime date;
  final String? userId;

  const BuyCurrencyEntity({
    required this.amount,
    required this.price,
    required this.currency,
    required this.date,
    this.userId,
  });

  factory BuyCurrencyEntity.fromModel(BuyCurrencyModel model) {
    return BuyCurrencyEntity(
      amount: model.amount,
      price: model.price,
      currency: model.currency,
      date: model.date,
      userId: model.userId,
    );
  }
}

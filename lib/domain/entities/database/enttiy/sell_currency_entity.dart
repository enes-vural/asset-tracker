import 'package:asset_tracker/data/model/base/base_model.dart';

final class SellCurrencyEntity implements BaseEntity {
  final String userId;
  final String currencyCode;
  final double amount;
  final double price;
  final double total;
  final double newPrice;
  final double profit;

  SellCurrencyEntity(
      {required this.userId,
      required this.currencyCode,
      required this.amount,
      required this.price,
      required this.total,
      required this.newPrice,
      required this.profit});

  @override
  toModel() {
    throw UnimplementedError();
  }
}

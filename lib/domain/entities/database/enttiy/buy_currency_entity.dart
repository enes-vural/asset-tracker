import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';

final class BuyCurrencyEntity implements BaseEntity {
  final String? docId;
  final double amount;
  final double price;
  final String currency;
  final DateTime date;
  final String? userId;
  final TransactionTypeEnum transactionType;

  const BuyCurrencyEntity(
    this.docId, {
    required this.amount,
    required this.price,
    required this.currency,
    required this.date,
    required this.transactionType,
    this.userId,
  });

  factory BuyCurrencyEntity.fromModel(BuyCurrencyModel model) {
    return BuyCurrencyEntity(
      model.docId,
      amount: model.amount,
      price: model.price,
      currency: model.currency,
      date: model.date,
      userId: model.userId,
      transactionType: model.transactionType,
    );
  }

  @override
  BuyCurrencyModel toModel() => BuyCurrencyModel.fromEntity(this);
}

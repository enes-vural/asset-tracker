import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';

final class SaveCurrencyEntity implements BaseEntity {
  final String? docId;
  final double? oldPrice;
  final double amount;
  final double price;
  final String currency;
  final DateTime date;
  final String? userId;
  final TransactionTypeEnum transactionType;

  const SaveCurrencyEntity(
    this.docId, {
    this.oldPrice,
    required this.amount,
    required this.price,
    required this.currency,
    required this.date,
    required this.transactionType,
    this.userId,
  });

  factory SaveCurrencyEntity.fromModel(SaveCurrencyModel model) {
    return SaveCurrencyEntity(
      oldPrice: model.oldPrice,
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
  SaveCurrencyModel toModel() => SaveCurrencyModel.fromEntity(this);
}

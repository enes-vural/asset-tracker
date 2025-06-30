import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/database/request/sell_currency_model.dart';

final class SellCurrencyEntity implements BaseEntity {
  final String? docId;
  final double sellAmount;
  final String currencyCode;
  final double sellPrice;
  final DateTime date;
  final double? buyPrice;
  final double? profit;
  final String userId;
  double get totalPrice => sellAmount * sellPrice;
  final TransactionTypeEnum transactionTypeEnum = TransactionTypeEnum.SELL;

  SellCurrencyEntity(
     {
    this.docId,
    this.buyPrice,
    this.profit,
    required this.sellAmount,
    required this.currencyCode,
    required this.sellPrice,
    required this.date,
    required this.userId,
  });

  @override
  toModel() => SellCurrencyModel(docId,
      buyPrice: buyPrice,
      sellAmount: sellAmount,
      currencyCode: currencyCode,
      sellPrice: sellPrice,
      date: date,
      userId: userId);
}

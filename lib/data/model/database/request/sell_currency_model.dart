import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/sell_currency_entity.dart';

final class SellCurrencyModel implements BaseModel {
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

  SellCurrencyModel(
    this.docId, {
    this.buyPrice,
    this.profit,
    required this.sellAmount,
    required this.currencyCode,
    required this.sellPrice,
    required this.date,
    required this.userId,
  });

  SellCurrencyModel copyWith({
    String? docId,
    String? userId,
    double? sellAmount,
    double? protif,
    double? amount,
    String? currencyCode,
    double? buyPrice,
    DateTime? date,
    double? sellPrice,
    double? price,
    double? total,
    TransactionTypeEnum? transactionType,
  }) {
    return SellCurrencyModel(
      docId ?? this.docId,
      sellAmount: sellAmount ?? this.sellAmount,
      currencyCode: currencyCode ?? this.currencyCode,
      sellPrice: sellPrice ?? this.sellPrice,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      buyPrice: buyPrice ?? this.buyPrice,
      profit: profit ?? this.profit,
    );
  }

  @override
  toEntity() => SellCurrencyEntity(
        docId: docId,
        buyPrice: buyPrice,
        sellAmount: sellAmount,
        currencyCode: currencyCode,
        sellPrice: sellPrice,
        date: date,
        userId: userId,
      );
}

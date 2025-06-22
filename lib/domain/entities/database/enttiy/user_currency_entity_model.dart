import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/data/model/database/response/user_currency_data_model.dart';

final class UserCurrencyEntity {
  final String? docId;
  final String userId;
  final double? oldPrice;
  final double amount;
  final String currencyCode;
  final DateTime buyDate;
  final double price;
  final double total;
  final TransactionTypeEnum transactionType;

  const UserCurrencyEntity(
     {
    this.docId,
    this.oldPrice,
    required this.userId,
    required this.amount,
    required this.currencyCode,
    required this.buyDate,
    required this.price,
    required this.total,
    required this.transactionType,
  });

  factory UserCurrencyEntity.fromModel(UserCurrencyDataModel model) {
    return UserCurrencyEntity(
      docId: model.docId,
      oldPrice: model.oldPrice,
      userId: model.userId,
      amount: model.amount,
      currencyCode: model.currencyCode,
      buyDate: model.buyDate.toDate(),
      price: model.price,
      total: model.total,
      transactionType: model.transactionType,
    );
  }

  UserCurrencyEntity copyWith({
    String? docId,
    String? userId,
    double? amount,
    String? currencyCode,
    DateTime? buyDate,
    double? price,
    double? total,
    double? oldPrice,
    TransactionTypeEnum? transactionType,
  }) {
    return UserCurrencyEntity(
      docId: docId ?? this.docId,
      oldPrice: oldPrice ?? this.oldPrice,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      buyDate: buyDate ?? this.buyDate,
      price: price ?? this.price,
      total: total ?? this.total,
      transactionType: transactionType ?? this.transactionType,
    );
  }
}

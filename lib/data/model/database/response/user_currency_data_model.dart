import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//TODO: SaveCurrencyModel ile birleştirilebilir.
final class UserCurrencyDataModel {
  final String? docId;
  final String userId;
  final double? oldPrice;
  final double amount;
  final String currencyCode;
  final Timestamp buyDate;
  final double price;
  final double total;
  final TransactionTypeEnum transactionType;

  UserCurrencyDataModel(
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

  factory UserCurrencyDataModel.fromEntity(
    UserCurrencyEntity entity,
  ) {
    return UserCurrencyDataModel(
      docId: entity.docId,
      oldPrice: entity.oldPrice,
      userId: entity.userId,
      amount: entity.amount,
      currencyCode: entity.currencyCode,
      buyDate: Timestamp.fromDate(entity.buyDate),
      price: entity.price,
      total: entity.total,
      transactionType: entity.transactionType,
    );
  }

  factory UserCurrencyDataModel.fromJson(Map<String, dynamic> json) {
    return UserCurrencyDataModel(
      docId: json['docId'],
      oldPrice: json['oldPrice'],
      userId: json['userId'] ?? 'N/A',
      amount: json['amount'] ?? 0.0,
      currencyCode: json['currency'] ?? 'N/A',
      buyDate: json['date'] ?? Timestamp.now(),
      price: json['price'] ?? 0.0,
      total: json['total'] ?? 0.0,
      transactionType:
          TransactionTypeEnum.values.firstWhere((e) => e.name == json['type']),
    );
  }

  UserCurrencyDataModel copyWith({
    String? docId,
    String? userId,
    double? amount,
    String? currencyCode,
    Timestamp? buyDate,
    double? price,
    double? total,
    double? oldPrice,
    TransactionTypeEnum? transactionType,
  }) {
    return UserCurrencyDataModel(
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

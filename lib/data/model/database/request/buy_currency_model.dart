import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/database/response/user_currency_data_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

final class BuyCurrencyModel extends Equatable implements BaseModel {
  final double amount;
  final double price;
  final String currency;
  final DateTime date;
  final String? userId;
  double get total => amount * price;
  final TransactionTypeEnum transactionType;

  const BuyCurrencyModel({
    required this.amount,
    required this.price,
    required this.currency,
    required this.date,
    required this.transactionType,
    this.userId,
  });

  //This json convert method is used for send data to firestore
  //The reason of use distract method from toJson
  //Example Scenario:
  // 1. User buy 1 BTC for 1000$ on 2023-10-01
  //we automatically save data as day format
  //and if user buy a new BTC in same day
  //we should update without create new document or overrite the old one
  //so we are increase the amount, price and total.
  Map<String, dynamic> toFirebaseJson() {
    return {
      'amount': FieldValue.increment(amount),
      'price': FieldValue.increment(price),
      'currency': currency,
      'date': date,
      'userId': userId,
      'total': FieldValue.increment(total),
      'type': transactionType.value,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'price': price,
      'currency': currency,
      'date': date,
      'userId': userId,
      'total': total,
      'type': transactionType.value,
    };
  }

  //Firestore doesnt use fromJson method
  //we are using different model class for receive user's asset
  //and we are using this model for send data to firestore
  //so we are not using fromJson method for database logics.
  //This methods is only for hive and local storage for set business logics in offline
  factory BuyCurrencyModel.fromJson(Map<String, dynamic> json) {
    return BuyCurrencyModel(
      amount: json['amount'] as double,
      price: json['price'] as double,
      currency: json['currency'] as String,
      date: json['date'] as DateTime,
      userId: json['userId'] as String?,
      transactionType: TransactionTypeEnum.values
          .firstWhere((e) => e.name == json['type'] as String),
    );
  }

  factory BuyCurrencyModel.fromEntity(BuyCurrencyEntity entity) {
    return BuyCurrencyModel(
      amount: entity.amount,
      price: entity.price,
      currency: entity.currency,
      date: entity.date,
      userId: entity.userId,
      transactionType: entity.transactionType,
    );
  }

  factory BuyCurrencyModel.fromUserCurrencyModel(
    UserCurrencyDataModel model,
  ) {
    return BuyCurrencyModel(
      amount: model.amount,
      price: model.price,
      currency: model.currencyCode,
      date: model.buyDate.toDate(),
      userId: model.userId,
      transactionType: model.transactionType,
    );
  }
  

  @override
  List<Object?> get props => [
        amount,
        price,
        currency,
        date,
        userId,
      ];

  @override
  bool? get stringify => true;

  @override
  BuyCurrencyEntity toEntity() => BuyCurrencyEntity.fromModel(this);
}

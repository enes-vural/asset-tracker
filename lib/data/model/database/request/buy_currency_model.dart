import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/database/request/sell_currency_model.dart';
import 'package:asset_tracker/data/model/database/response/user_currency_data_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/env/envied.dart';
import 'package:equatable/equatable.dart';

final class SaveCurrencyModel extends Equatable implements BaseModel {
  final String? docId;
  //bought price parameter for sell currency models.
  final double? oldPrice;
  final double amount;
  final double price;
  final String currency;
  final DateTime date;
  final String? userId;
  double get total => amount * price;
  final TransactionTypeEnum transactionType;

  const SaveCurrencyModel(
    this.docId, {
    this.oldPrice,
    required this.amount,
    required this.price,
    required this.currency,
    required this.date,
    required this.transactionType,
    this.userId,
  });

  SaveCurrencyModel changeWithDocId({
    String? docId,
  }) {
    return SaveCurrencyModel(
      oldPrice: oldPrice,
      docId ?? this.docId,
      amount: amount,
      price: price,
      currency: currency,
      date: date,
      transactionType: transactionType,
      userId: userId,
    );
  }

  //This json convert method is used for send data to firestore
  //The reason of use distract method from toJson
  //Example Scenario:
  // 1. User buy 1 BTC for 1000$ on 2023-10-01
  //we automatically save data as day format
  //and if user buy a new BTC in same day
  //we should update without create new document or overrite the old one
  //so we are increase the amount, price and total.
  Map<String, dynamic> toFirebaseJson() {
    final Env env = Env();
    return {
      if (oldPrice != null) 'oldPrice': env.encryptText(oldPrice.toString()),
      'docId': docId,
      'amount': env.encryptText(amount.toString()),
      'price': env.encryptText(price.toString()),
      'currency': env.encryptText(currency),
      'date': date,
      'userId': userId.toString(),
      'total': env.encryptText(total.toString()),
      'type': env.encryptText(transactionType.value),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'oldPrice': oldPrice,
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
  factory SaveCurrencyModel.fromJson(Map<String, dynamic> json) {
    final Env env = Env();
    return SaveCurrencyModel(
      //docId daha sonra service katmanından copyWith ile eklenecek
      json['docId'],
      oldPrice: double.tryParse(env.tryDecrypt(json['oldPrice'])) ?? 0.0,
      amount: double.tryParse(env.tryDecrypt(json['amount'])) ?? 0.0,
      price: double.tryParse(env.tryDecrypt(json['price'])) ?? 0.0,
      currency: env.tryDecrypt(json['currency'] as String),
      date: json['date'] as DateTime,
      userId: json['userId'],
      transactionType: TransactionTypeEnum.values
          .firstWhere((e) => e.name == env.tryDecrypt(json['type'] as String)),
    );
  }

  factory SaveCurrencyModel.fromEntity(SaveCurrencyEntity entity) {
    return SaveCurrencyModel(
      oldPrice: entity.oldPrice,
      entity.docId,
      amount: entity.amount,
      price: entity.price,
      currency: entity.currency,
      date: entity.date,
      userId: entity.userId,
      transactionType: entity.transactionType,
    );
  }

  factory SaveCurrencyModel.fromUserCurrencyModel(
    UserCurrencyDataModel model,
  ) {
    return SaveCurrencyModel(
      null,
      oldPrice: null,
      amount: model.amount,
      price: model.price,
      currency: model.currencyCode,
      date: model.buyDate.toDate(),
      userId: model.userId,
      transactionType: model.transactionType,
    );
  }

  factory SaveCurrencyModel.fromSellCurrencyModel(SellCurrencyModel model) {
    return SaveCurrencyModel(
      oldPrice: model.buyPrice,
      model.docId,
      amount: model.sellAmount,
      price: model.sellPrice,
      currency: model.currencyCode,
      date: model.date,
      transactionType: model.transactionTypeEnum,
      userId: model.userId,
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
  SaveCurrencyEntity toEntity() => SaveCurrencyEntity.fromModel(this);
}

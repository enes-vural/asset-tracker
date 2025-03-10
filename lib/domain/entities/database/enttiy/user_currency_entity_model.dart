import 'package:asset_tracker/data/model/user_currency_data_model.dart';

final class UserCurrencyEntityModel {
  final double amount;
  final String currencyCode;
  final DateTime buyDate;
  final double price;
  final double total;

  const UserCurrencyEntityModel({
    required this.amount,
    required this.currencyCode,
    required this.buyDate,
    required this.price,
    required this.total,
  });

  factory UserCurrencyEntityModel.fromModel(UserCurrencyDataModel model) {
    return UserCurrencyEntityModel(
      amount: model.amount,
      currencyCode: model.currencyCode,
      buyDate: model.buyDate.toDate(),
      price: model.price,
      total: model.total,
    );
  }
}

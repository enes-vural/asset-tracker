import 'package:asset_tracker/data/model/database/response/user_currency_data_model.dart';

final class UserCurrencyEntity {
  final String userId;
  final double amount;
  final String currencyCode;
  final DateTime buyDate;
  final double price;
  final double total;

  const UserCurrencyEntity({
    required this.userId,
    required this.amount,
    required this.currencyCode,
    required this.buyDate,
    required this.price,
    required this.total,
  });

  factory UserCurrencyEntity.fromModel(UserCurrencyDataModel model) {
    return UserCurrencyEntity(
      userId: model.userId,
      amount: model.amount,
      currencyCode: model.currencyCode,
      buyDate: model.buyDate.toDate(),
      price: model.price,
      total: model.total,
    );
  }
}

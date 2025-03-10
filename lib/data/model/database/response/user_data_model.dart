import 'package:asset_tracker/data/model/user_currency_data_model.dart';

final class UserDataModel {
  final List<UserCurrencyDataModel> currencyList;
  final String uid;
  double balance;

  UserDataModel({
    required this.currencyList,
    required this.uid,
    this.balance = 0.00,
  });
}

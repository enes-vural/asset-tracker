import 'package:asset_tracker/data/model/database/response/user_data_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';

final class UserDataEntity {
  final String userId;
  final List<UserCurrencyEntity> currencyList;
  final double balance;
  final double? latestBalance;
  final double? profit;

  const UserDataEntity({
    required this.userId,
    required this.currencyList,
    required this.balance,
    this.latestBalance = 0.00,
    this.profit = 0.00,
  });

  factory UserDataEntity.fromModel(UserDataModel model) {
    return UserDataEntity(
      userId: model.uid,
      currencyList: model.currencyList
          .map((e) => UserCurrencyEntity.fromModel(e))
          .toList(),
      balance: model.balance,
    );
  }

  UserDataEntity copyWith({
    List<UserCurrencyEntity>? currencyList,
    String? uid,
    double? balance,
    double? profit,
    double? latestBalance,
  }) {
    return UserDataEntity(
      currencyList: currencyList ?? this.currencyList,
      userId: uid ?? userId,
      balance: balance ?? this.balance,
      profit: profit ?? this.profit,
      latestBalance: latestBalance ?? this.latestBalance,
    );
  }
}

import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/data/model/database/alarm_model.dart';
import 'package:asset_tracker/data/model/database/response/user_data_model.dart';
import 'package:asset_tracker/domain/entities/database/alarm_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_info_entity.dart';

final class UserDataEntity {
  UserInfoEntity? userInfoEntity;
  final String userId;
  final List<UserCurrencyEntity> currencyList;
  List<UserCurrencyEntity>? soldCurrencyList;
  final double balance;
  List<AlarmEntity>? userAlarmList;
  final double? latestBalance;
  final double? profit;

  UserDataEntity({
    this.userInfoEntity,
    required this.userId,
    required this.currencyList,
    required this.userAlarmList,
    required this.balance,
    this.latestBalance = 0.00,
    this.profit = 0.00,
    this.soldCurrencyList,
  });

  factory UserDataEntity.fromModel(UserDataModel model) {
    return UserDataEntity(
      userAlarmList: model.userAlarmList
              ?.map((AlarmModel e) => e.toEntity())
              .toList()
              .cast<AlarmEntity>() ??
          <AlarmEntity>[],
      userInfoEntity: model.userInfoModel?.toEntity(),
      userId: model.uid,
      currencyList: model.currencyList
          .where((e) => e.transactionType == TransactionTypeEnum.BUY)
          .map((e) => UserCurrencyEntity.fromModel(e))
          .toList(),
      balance: model.balance,
      soldCurrencyList: model.currencyList
          .where((e) => e.transactionType == TransactionTypeEnum.SELL)
          .map((e) => UserCurrencyEntity.fromModel(e))
          .toList(),
    );
  }

  UserDataEntity copyWith({
    List<UserCurrencyEntity>? currencyList,
    String? uid,
    double? balance,
    double? profit,
    String? firstName,
    String? lastName,
    double? latestBalance,
    List<UserCurrencyEntity>? soldCurrencyList,
    List<AlarmEntity>? userAlarmList,
    
    UserInfoEntity? userInfoEntity,
  }) {
    return UserDataEntity(
      userAlarmList: userAlarmList ?? this.userAlarmList,
      userInfoEntity: userInfoEntity ?? this.userInfoEntity,
      currencyList: currencyList ?? this.currencyList,
      userId: uid ?? userId,
      balance: balance ?? this.balance,
      profit: profit ?? this.profit,
      latestBalance: latestBalance ?? this.latestBalance,
      soldCurrencyList: soldCurrencyList ?? this.soldCurrencyList,
    );
  }
}

import 'package:asset_tracker/data/model/database/response/user_data_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';

final class UserDataEntity {
  final String userId;
  final List<UserCurrencyEntityModel> currencyList;
  final double balance;

  const UserDataEntity({
    required this.userId,
    required this.currencyList,
    required this.balance,
  });

  factory UserDataEntity.fromModel(UserDataModel model) {
    return UserDataEntity(
      userId: model.uid,
      currencyList: model.currencyList
          .map((e) => UserCurrencyEntityModel.fromModel(e))
          .toList(),
      balance: model.balance,
    );
  }
}

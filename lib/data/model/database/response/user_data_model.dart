import 'package:asset_tracker/data/model/database/alarm_model.dart';
import 'package:asset_tracker/data/model/database/response/user_currency_data_model.dart';
import 'package:asset_tracker/data/model/database/user_info_model.dart';

final class UserDataModel {
  UserInfoModel? userInfoModel;
  final List<UserCurrencyDataModel> currencyList;
  final List<AlarmModel>? userAlarmList;
  final String uid;
  double balance;

  UserDataModel({
    this.userInfoModel,
    required this.currencyList,
    required this.userAlarmList,
    required this.uid,
    this.balance = 0.00,
  });
}

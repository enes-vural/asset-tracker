import 'package:asset_tracker/domain/entities/database/alarm_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/sell_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_info_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:asset_tracker/domain/entities/database/request/save_user_entity.dart';
import 'package:dartz/dartz.dart' show Either;

abstract interface class IFirestoreRepository {
  Future<Either<DatabaseErrorEntity, SaveCurrencyEntity>> buyCurrency(
      SaveCurrencyEntity entity);

  Future<Either<DatabaseErrorEntity, UserDataEntity>> getUserData(
      UserUidEntity model);

  Future<Either<DatabaseErrorEntity, bool>> deleteUserTransaction(
      UserCurrencyEntity entity);

  Future<Either<DatabaseErrorEntity, bool>> sellCurrency(
      SellCurrencyEntity entity);

  Future<Either<DatabaseErrorEntity, bool>> toggleAlarmStatus(
      AlarmEntity entity);
  Future<Either<DatabaseErrorEntity, bool>> updateAlarm(AlarmEntity entity);

  Future<Either<DatabaseErrorEntity, bool>> deleteAlarm(AlarmEntity entity);

  Future<List<AlarmEntity>?> getUserAlarms(UserUidEntity entity);

  Future<Either<DatabaseErrorEntity, bool>> saveUserAlarm(AlarmEntity entity);

  Future<void> saveUserToken(
      UserUidEntity entity, String token, String? widgetToken);

  Future<Either<DatabaseErrorEntity, bool>> saveUser(SaveUserEntity entity);

  Future<Either<DatabaseErrorEntity, bool>> removeUser(UserUidEntity model);

  Future<Either<DatabaseErrorEntity, bool>> changeUserInfo(
      UserInfoEntity infoModel);
}

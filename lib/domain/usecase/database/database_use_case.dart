import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';
import 'package:asset_tracker/domain/entities/database/alarm_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/sell_currency_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_info_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:asset_tracker/domain/entities/database/request/save_user_entity.dart';
import 'package:asset_tracker/domain/repository/database/firestore/ifirestore_repository.dart';
import 'package:asset_tracker/domain/usecase/base/base_use_case.dart';
import 'package:dartz/dartz.dart';

//TODO: Use caseler databsae use case altına toplanacak.
class DatabaseUseCase
    extends BaseUseCase<SaveCurrencyEntity, SaveCurrencyEntity> {
  final IFirestoreRepository firestoreRepository;

  DatabaseUseCase({required this.firestoreRepository});

  @override
  Future<Either<BaseErrorEntity, SaveCurrencyEntity>> call(params) async {
    return await firestoreRepository.buyCurrency(params);
  }

  Future<Either<BaseErrorEntity, bool>> deleteUserTransaction(
      UserCurrencyEntity entity) async {
    return await firestoreRepository.deleteUserTransaction(entity);
  }

  Future<Either<BaseErrorEntity, bool>> sellCurrency(
      SellCurrencyEntity entity) async {
    return await firestoreRepository.sellCurrency(entity);
  }

  Future<Either<DatabaseErrorEntity, UserDataEntity>> getUserData(
      UserUidEntity params) async {
    return await firestoreRepository.getUserData(params);
  }

  Future<Either<DatabaseErrorEntity, bool>> saveUserData(
      SaveUserEntity params) async {
    return await firestoreRepository.saveUser(params);
  }

  Future<Either<DatabaseErrorEntity, bool>> removeUserData(
      UserUidEntity entity) async {
    return await firestoreRepository.removeUser(entity);
  }

  Future<Either<DatabaseErrorEntity, bool>> changeUserInfo(
      UserInfoEntity entity) async {
    return await firestoreRepository.changeUserInfo(entity);
  }

  Future<void> saveUserToken(UserUidEntity entity, String token) async {
    return await firestoreRepository.saveUserToken(entity, token);
  }

  Future<Either<DatabaseErrorEntity, bool>> saveUserAlarm(
      AlarmEntity entity) async {
    return await firestoreRepository.saveUserAlarm(entity);
  }

  Future<List<AlarmEntity>?> getUserAlarms(UserUidEntity entity) async {
    return await firestoreRepository.getUserAlarms(entity);
  }

  Future<Either<DatabaseErrorEntity, bool>> toggleAlarmStatus(
      AlarmEntity entity) async {
    return await firestoreRepository.toggleAlarmStatus(entity);
  }

  Future<Either<DatabaseErrorEntity, bool>> updateAlarm(
      AlarmEntity entity) async {
    return await firestoreRepository.updateAlarm(entity);
  }

  Future<Either<DatabaseErrorEntity, bool>> deleteAlarm(
      AlarmEntity entity) async {
    return await firestoreRepository.deleteAlarm(entity);
  }
}

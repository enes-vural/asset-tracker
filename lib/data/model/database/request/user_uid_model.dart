import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';

final class UserUidModel {
  final String userId;

  const UserUidModel({required this.userId});

  UserUidModel.fromEnttiy(UserUidEntity entity) : userId = entity.userId;
}

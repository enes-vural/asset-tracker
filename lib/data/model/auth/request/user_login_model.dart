import 'package:asset_tracker/domain/entities/auth/request/user_login_entity.dart';

final class UserLoginModel {
  final String userName;
  final String password;
  const UserLoginModel({
    required this.userName,
    required this.password,
  });

  factory UserLoginModel.fromEntity(UserLoginEntity entity) {
    return UserLoginModel(
      userName: entity.userName,
      password: entity.password,
    );
  }
}

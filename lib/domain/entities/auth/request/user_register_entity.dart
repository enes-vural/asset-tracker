import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';

final class UserRegisterEntity {
  final String userName;
  final String password;
  const UserRegisterEntity({
    required this.userName,
    required this.password,
  });

  factory UserRegisterEntity.fromModel(UserRegisterModel model) {
    return UserRegisterEntity(
      userName: model.userName,
      password: model.password,
    );
  }
}

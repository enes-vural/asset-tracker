import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';

class UserLoginEntity implements BaseEntity {
  final String userName;
  final String password;

  const UserLoginEntity({
    required this.userName,
    required this.password,
  });

  factory UserLoginEntity.fromModel(UserLoginModel model) {
    return UserLoginEntity(
      userName: model.userName,
      password: model.password,
    );
  }

  @override
  UserLoginModel toModel() => UserLoginModel.fromEntity(this);

  
}

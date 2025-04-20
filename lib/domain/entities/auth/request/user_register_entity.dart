import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';

final class UserRegisterEntity implements BaseEntity {
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
  
  @override
  UserRegisterModel toModel() => UserRegisterModel.fromEntity(this);

  
}

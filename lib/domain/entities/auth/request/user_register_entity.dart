import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';

final class UserRegisterEntity implements BaseEntity {
  final String userName;
  final String password;
  final String firstName;
  final String lastName;
  const UserRegisterEntity({
    required this.userName,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  factory UserRegisterEntity.fromModel(UserRegisterModel model) {
    return UserRegisterEntity(
      userName: model.userName,
      password: model.password,
      firstName: model.firstName,
      lastName: model.lastName,
    );
  }

  @override
  UserRegisterModel toModel() => UserRegisterModel.fromEntity(this);
}

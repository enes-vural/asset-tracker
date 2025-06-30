import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_login_entity.dart';

final class UserLoginModel implements BaseModel {
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
  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
      userName: json['userName'] as String,
      password: json['password'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
    };
  }

  @override
  UserLoginEntity toEntity() => UserLoginEntity.fromModel(this);
}

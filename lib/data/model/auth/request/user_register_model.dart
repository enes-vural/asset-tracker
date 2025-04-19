import 'package:asset_tracker/domain/entities/auth/request/user_register_entity.dart';

final class UserRegisterModel {
  final String userName;
  final String password;
  const UserRegisterModel({
    required this.userName,
    required this.password,
  });

  factory UserRegisterModel.fromEntity(UserRegisterEntity entity) {
    return UserRegisterModel(
      userName: entity.userName,
      password: entity.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
    };
  }

  factory UserRegisterModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterModel(
      userName: json['userName'] as String,
      password: json['password'] as String,
    );
  }
}

import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_register_entity.dart';

final class UserRegisterModel implements BaseModel {
  final String userName;
  final String password;
  final String firstName;
  final String lastName;
  const UserRegisterModel({
    required this.userName,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  factory UserRegisterModel.fromEntity(UserRegisterEntity entity) {
    return UserRegisterModel(
      userName: entity.userName,
      password: entity.password,
      firstName: entity.firstName,
      lastName: entity.lastName,

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
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  @override
  UserRegisterEntity toEntity() => UserRegisterEntity.fromModel(this);
}

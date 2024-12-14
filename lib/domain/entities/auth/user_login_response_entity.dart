import 'package:asset_tracker/data/model/auth/response/user_login_response_model.dart';

class UserLoginResponseEntity {
  final String token;

  UserLoginResponseEntity({required this.token});

  factory UserLoginResponseEntity.fromModel(
      UserLoginResponseModel userRespModel) {
    return UserLoginResponseEntity(token: userRespModel.token);
  }
}

import 'package:asset_tracker/data/model/auth/response/user_login_response_model.dart';

class UserLoginResponseEntity {
  final String uid;

  UserLoginResponseEntity({required this.uid});

  factory UserLoginResponseEntity.fromModel(
      UserLoginResponseModel userRespModel) {
    return UserLoginResponseEntity(uid: userRespModel.uid);
  }
}

import 'package:asset_tracker/data/model/auth/response/user_register_response_model.dart';

final class UserRegisterReponseEntity {
  final String uid;
  final String userName;
  final String password;

  const UserRegisterReponseEntity({
    required this.uid,
    required this.userName,
    required this.password,
  });

  factory UserRegisterReponseEntity.fromModel(
      UserRegisterReponseModel userRespModel) {
    return UserRegisterReponseEntity(
      uid: userRespModel.uid,
      userName: userRespModel.userName,
      password: userRespModel.password,
    );
  }
}

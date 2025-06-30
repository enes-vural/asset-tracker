import 'package:asset_tracker/domain/entities/auth/response/user_register_reponse_entity.dart';

final class SaveUserEntity {
  final String uid;
  final String userName;
  final String firstName;
  final String lastName;

  SaveUserEntity({
    required this.uid,
    required this.userName,
    required this.firstName,
    required this.lastName,
  });

  factory SaveUserEntity.fromAuthResponse(
      UserRegisterReponseEntity entity, String firstName, String lastName) {
    return SaveUserEntity(
      uid: entity.uid,
      userName: entity.userName,
      firstName: firstName,
      lastName: lastName,
    );
  }
}

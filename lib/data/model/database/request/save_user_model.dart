import 'package:asset_tracker/domain/entities/database/request/save_user_entity.dart';
import 'package:asset_tracker/env/envied.dart';

final class SaveUserModel {
  final String uid;
  final String userName;
  final String firstName;
  final String lastName;

  const SaveUserModel({
    required this.uid,
    required this.userName,
    required this.firstName,
    required this.lastName,
  });

  factory SaveUserModel.fromEntity(SaveUserEntity entity) {
    return SaveUserModel(
      uid: entity.uid,
      userName: entity.userName,
      firstName: entity.firstName,
      lastName: entity.lastName,
    );
  }

  Map<String, dynamic> toJson() {
    final Env env = Env();
    return {
      'uid': uid,
      'userName': env.encryptText(userName),
      'firstName': env.encryptText(firstName),
      'lastName': env.encryptText(lastName),
    };
  }
}

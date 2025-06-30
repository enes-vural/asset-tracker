import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_info_entity.dart';
import 'package:asset_tracker/env/envied.dart';

final class UserInfoModel implements BaseModel {
  final String email;
  final String uid;
  final String firstName;
  final String lastName;

  UserInfoModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  @override
  toEntity() => UserInfoEntity(
        email: email,
        firstName: firstName,
        lastName: lastName,
        uid: uid,
      );

  static UserInfoModel fromJson(Map<String, dynamic> json) {
    final env = Env();
    return UserInfoModel(
      //username eklentisi gelirse email yerine farlklı olarak firebase e kaydedilebilir.
      uid: json['uid'],
      email: env.tryDecrypt(json['userName'] ?? ""),
      firstName: env.tryDecrypt(json['firstName'] ?? ""),
      lastName: env.tryDecrypt(json['lastName'] ?? ""),
    );
  }

  Map<String, dynamic> toJson() {
    final env = Env();
    return {
      'uid': uid,
      'userName': env.encryptText(email),
      'firstName': env.encryptText(firstName),
      'lastName': env.encryptText(lastName),
    };
  }
}

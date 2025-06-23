import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/database/user_info_model.dart';

final class UserInfoEntity implements BaseEntity {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;

  UserInfoEntity({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  UserInfoEntity copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
  }) {
    return UserInfoEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  @override
  toModel() => UserInfoModel(
        email: email,
        firstName: firstName,
        lastName: lastName,
        uid: uid,
      );
}

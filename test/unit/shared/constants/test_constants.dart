import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';

final class TestConstants {
  TestConstants._();

  static const String wrongEmail = "wrongemail@.com";
  static const String correctEmail = "correct@gmail.com";
  static const String wrongPassword = "123";
  static const String correctPassword = "123456";

  static const UserLoginEntity successLoginEntity =
      UserLoginEntity(userName: correctEmail, password: correctPassword);
  static const UserLoginEntity failureLoginEntity =
      UserLoginEntity(userName: wrongEmail, password: wrongPassword);
}

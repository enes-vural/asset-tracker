import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';

//Tüm Servislerin toplandığı çatı görebi gören bir imza sınıfı.
abstract interface class IAuthService<T> {
  Future<T>? signInUser(UserLoginEntity entity);

  String? getUserId();

  Stream getUserStateChanges();

  Future<void> signOutUser();
}

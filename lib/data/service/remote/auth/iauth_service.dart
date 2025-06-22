import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';

//Tüm Servislerin toplandığı çatı görebi gören bir imza sınıfı.
abstract interface class IAuthService<L, R> {
  Future<L>? signInUser(UserLoginModel model);

  String? getUserId();

  Stream getUserStateChanges();

  Future<void> signOutUser();
  // TODO: T Type verilecek
  Future<R>? registerUser(UserRegisterModel model);

  Future<void> sendResetPasswordLink(String email);
}

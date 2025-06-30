import 'package:asset_tracker/data/model/auth/error/auth_response_model.dart'
    show AuthErrorModel;
import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';
import 'package:asset_tracker/data/model/database/error/database_error_model.dart';
import 'package:dartz/dartz.dart';
//Tüm Servislerin toplandığı çatı görebi gören bir imza sınıfı.
abstract interface class IAuthService<L, R, E> {
  Future<L>? signInUser(UserLoginModel model);

  String? getUserId();

  Stream getUserStateChanges();

  Future<void> signOutUser();
  // TODO: T Type verilecek
  Future<R>? registerUser(UserRegisterModel model);

  Future<void> sendResetPasswordLink(String email);
  //Auth Credential şu anda sarmalayan bir class yok o yüzden E type
  Future<L?> signInWithCredential(E credential);

  Future<Either<AuthErrorModel, bool>> deleteAccount();

  Future<Either<DatabaseErrorModel, bool>> sendEmailVerification();
}

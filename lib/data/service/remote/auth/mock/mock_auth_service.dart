import 'package:asset_tracker/data/model/auth/mock_user_credentials_model.dart';
import 'package:asset_tracker/data/service/remote/auth/iauth_service.dart';
import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

//MockAuthService sınıfı IAuthService sınıfını implemente eder.
//Otomatik olarak 1 saniye sonra gerekli parametreleri içeren mock sınıfını döndürür.

class MockAuthService implements IAuthService {
  @override
  Future<UserCredential>? signInUser(UserLoginEntity entity) {
    final mockUserCreds = MockUserCredentialsModel();
    return Future.delayed(const Duration(seconds: 1), () => mockUserCreds);
  }
}

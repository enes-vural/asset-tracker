import 'package:asset_tracker/data/model/auth/mock_auth_user_model.dart';
import 'package:asset_tracker/data/service/remote/auth/mock/imock_auth_service.dart';
import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';

//MockAuthService sınıfı IAuthService sınıfını implemente eder.
//Otomatik olarak 1 saniye sonra gerekli parametreleri içeren mock sınıfını döndürür.

class MockAuthService implements IMockAuthService {
  @override
  Future<MockAuthUserModel>? signInUser(UserLoginEntity entity) {
    if (entity.userName != "test@gmail.com" && entity.password != "123456") {
      return null;
    }
    final mockUserCreds = _correctModel(entity);
    return Future.delayed(const Duration(seconds: 1), () => mockUserCreds);
  }

  MockAuthUserModel _correctModel(UserLoginEntity entity) {
    return MockAuthUserModel(
        email: entity.userName,
        uid: "123456",
        emailVerified: true,
        displayName: "Test User",
        idToken: "Test-User-ID-Token_SUCCESS");
  }
}

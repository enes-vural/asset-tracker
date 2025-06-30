import 'package:asset_tracker/data/model/auth/mock_auth_user_model.dart';
import 'package:asset_tracker/data/model/auth/mock_user_credentinal.dart';
import 'package:asset_tracker/data/service/remote/auth/iauth_service.dart';

//MockService'in imzalarını taşıyan IMockAuthService sınıfı
//bu sınıfta bir daha ekstaradan model sınıfı tanımlamak yerine kendi
//oluşturduğum mockUserCredentinal sınıfını kullanacağım
//o yüzden UserCredentinal? type ını vermekte bir problem yok.
//farklı durumlarda UserCred yerine uid ve token parametreleri içeren
//CustomAuthModel sınıfı da oluşturabilir.

abstract interface class IMockAuthService
    implements IAuthService<MockAuthUserModel, MockUserCredentinal, dynamic> {}

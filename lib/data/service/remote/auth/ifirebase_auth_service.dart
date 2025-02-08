import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/data/service/remote/auth/iauth_service.dart';
import '../../../../domain/entities/auth/user_login_entity.dart';

abstract interface class IFirebaseAuthService implements IAuthService {
  @override
  Future<FirebaseAuthUser>? signInUser(UserLoginEntity entity);
}

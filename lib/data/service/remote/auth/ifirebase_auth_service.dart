import 'package:asset_tracker/data/service/remote/auth/iauth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../domain/entities/auth/user_login_entity.dart';

abstract interface class IFirebaseAuthService implements IAuthService {
  @override
  Future<UserCredential>? signInUser(UserLoginEntity entity);
}

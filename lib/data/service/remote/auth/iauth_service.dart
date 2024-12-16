import 'package:firebase_auth/firebase_auth.dart';

import '../../../../domain/entities/auth/user_login_entity.dart';

abstract interface class IAuthService {
  Future<UserCredential>? signInUser(UserLoginEntity entity);
}

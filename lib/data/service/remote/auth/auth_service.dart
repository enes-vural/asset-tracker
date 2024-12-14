import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _authService = FirebaseAuth.instance;

  Future<UserCredential>? signInUser(UserLoginEntity entity) async {
    return await _authService.signInWithEmailAndPassword(
        email: entity.userName, password: entity.password);
  }
}

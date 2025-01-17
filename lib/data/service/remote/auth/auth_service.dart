import 'package:asset_tracker/data/service/remote/auth/iauth_service.dart';
import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth authService;
  FirebaseAuthService({required this.authService});

  @override
  Future<UserCredential>? signInUser(UserLoginEntity entity) async {
    return await authService.signInWithEmailAndPassword(
        email: entity.userName, password: entity.password);
  }
}

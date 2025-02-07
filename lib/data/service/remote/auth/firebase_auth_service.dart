import 'package:asset_tracker/data/service/remote/auth/ifirebase_auth_service.dart';
import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements IFirebaseAuthService {
  final FirebaseAuth authService;
  FirebaseAuthService({required this.authService});

  @override
  Future<UserCredential>? signInUser(UserLoginEntity entity) async {
    return await authService.signInWithEmailAndPassword(
        email: entity.userName, password: entity.password);
  }
}

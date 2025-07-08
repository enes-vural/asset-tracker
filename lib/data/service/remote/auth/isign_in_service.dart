import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';

abstract interface class ISignInService {
  Future<void> initialize();

  Future<FirebaseAuthUser?> signIn();

  Future<void> signOut();

  FirebaseAuthUser? get currentUser;
}

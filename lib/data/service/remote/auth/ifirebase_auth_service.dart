import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/data/service/remote/auth/iauth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
abstract interface class IFirebaseAuthService
    implements IAuthService<FirebaseAuthUser, UserCredential> {
}

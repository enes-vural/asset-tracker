import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart'
    show FirebaseAuthUser;

abstract interface class IGoogleSignInRepository {
  /// Initializes the Google Sign-In service.
  Future<void> initialize();

  /// Attempts to sign in the user with Google.
  Future<FirebaseAuthUser?> signInWithGoogle();

  /// Signs out the current user.
  Future<void> signOut();
}

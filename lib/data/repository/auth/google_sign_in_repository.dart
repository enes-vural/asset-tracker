import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/data/service/remote/auth/google_sign_in_service.dart';
import 'package:asset_tracker/data/service/remote/auth/ifirebase_auth_service.dart';
import 'package:asset_tracker/domain/repository/auth/igoogle_sign_in_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final class GoogleSignInRepository implements IGoogleSignInRepository {
  final GoogleSignInService googleSignInService;
  final IFirebaseAuthService firebaseAuthService;

  GoogleSignInRepository(
    this.googleSignInService,
    this.firebaseAuthService,
  );

  @override
  Future<void> initialize() async {
    await googleSignInService.initialize();
    await _callSignInWithCredential();
  }

  //buradaki _callSignInWithCredential metodu, GoogleSignInAccount parametresi alabilir
  //Bu parametre account parametresi signIn methodundan gecikmesiz döner.
  //Ama account parametresi splash tarafından geliyorsa bu gecikmeli gelebilir bu da
  //error a neden olabilir.
  //Bu yüzden eğer account u signIn tarafından çağırıyorsak state in yenilenmesini beklemeden.
  //SDK dan dönen account u atıyoruz.
  //Eğer account parametresi null ise o zaman splash tarafından çağırılmıştır.
  //Eğer account null ise o zaman googleSignInService.currentUser dan alıyoruz.
  //Eğer o da null ise zaten kullanıcı giriş yapmamıştır.
  Future<FirebaseAuthUser?> _callSignInWithCredential(
      [GoogleSignInAccount? account]) async {
    if (account != null) {
      final GoogleSignInAuthentication googleAuth = account.authentication;
      final credential = _createCredential(googleAuth);
      return await firebaseAuthService.signInWithCredential(credential);
    } else {
      GoogleSignInAccount? account = googleSignInService.currentUser;
      if (account == null) {
        return null;
      }

      final credential = _createCredential(account.authentication);
      return await firebaseAuthService.signInWithCredential(credential);
    }
  }

  OAuthCredential _createCredential(GoogleSignInAuthentication googleAuth) {
    return GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
  }

  @override
  Future<FirebaseAuthUser?> signInWithGoogle() async {
    try {
      final account = await googleSignInService.signIn();
      final authUser = await _callSignInWithCredential(account);
      return authUser;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await googleSignInService.signOut();
  }
}

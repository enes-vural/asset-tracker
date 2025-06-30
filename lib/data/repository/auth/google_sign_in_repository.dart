import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/data/service/remote/auth/firebase_auth_service.dart';
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

  Future _callSignInWithCredential() async {
    final GoogleSignInAccount? account = googleSignInService.currentUser;
    if (account != null) {
      final GoogleSignInAuthentication googleAuth = account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      return await firebaseAuthService.signInWithCredential(credential);
    }
    return null;
  }

  @override
  Future<FirebaseAuthUser?> signInWithGoogle() async {
    try {
      await googleSignInService.signIn();
      return await _callSignInWithCredential();
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

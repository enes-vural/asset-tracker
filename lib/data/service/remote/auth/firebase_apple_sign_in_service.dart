import 'dart:io';

import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/data/service/remote/auth/isign_in_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final class FirebaseAppleSignInService implements ISignInService {
  final FirebaseAuth firebaseAuth;
  final AppleAuthProvider appleAuthProvider;

  FirebaseAppleSignInService(this.firebaseAuth, this.appleAuthProvider);

  @override
  get currentUser => throw UnimplementedError();

  @override
  Future<void> initialize() async {
    if (Platform.isIOS) {
      appleAuthProvider.addScope('email').addScope('name');
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<FirebaseAuthUser?> signIn() async {
    try {
      final creds = await firebaseAuth.signInWithProvider(appleAuthProvider);
      if (creds.user != null) {
        final idToken = await creds.user?.getIdToken();
        return FirebaseAuthUser(user: creds.user, idToken: idToken);
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    return null;
  }
}

import 'dart:async';
import 'dart:io' show Platform;
import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/data/service/remote/auth/isign_in_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final class GoogleSignInService implements ISignInService {
  final GoogleSignIn googleSignIn;

  GoogleSignInService(this.googleSignIn);

  FirebaseAuthUser? _currentUser;

  // Initialize metodunu constructor veya initState'te çağır
  @override
  Future<void> initialize() async {
    unawaited(googleSignIn.initialize(
      clientId: Platform.isAndroid
          ? '720693227761-jlo1i0q84h9i1uhon614e1hqbgq2sasl.apps.googleusercontent.com'
          : null,
    ));
  }

  @override
  Future<FirebaseAuthUser?> signIn() async {
    try {
      final gAccount = await googleSignIn.authenticate();
      final account = FirebaseAuthUser.fromGoogle(
          googleUser: gAccount, idToken: gAccount.authentication.idToken);
      return account;
    } catch (error) {
      debugPrint('Sign-in error: $error');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
    _currentUser = null;
  }

  @override
  FirebaseAuthUser? get currentUser => _currentUser;
}

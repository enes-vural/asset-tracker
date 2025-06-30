import 'dart:async';

import 'package:asset_tracker/data/service/remote/auth/isign_in_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService implements ISignInService<GoogleSignInAccount> {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _currentUser;

  // Initialize metodunu constructor veya initState'te çağır
  @override
  Future<void> initialize() async {
    unawaited(_googleSignIn.initialize().then((_) {
      _googleSignIn.authenticationEvents
          .listen(_handleAuthenticationEvent)
          .onError(_handleAuthenticationError);

      /// This example always uses the stream-based approach to determining
      /// which UI state to show, rather than using the future returned here,
      /// if any, to conditionally skip directly to the signed-in state.
      _googleSignIn.attemptLightweightAuthentication();
    }));
  }

  @override
  Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.authenticate();
      return account;
    } catch (error) {
      debugPrint('Sign-in error: $error');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  Future<void> _handleAuthenticationEvent(
      GoogleSignInAuthenticationEvent event) async {
    const List<String> scopes = <String>[
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ];
    // #docregion CheckAuthorization
    GoogleSignInAccount? user;
    // #enddocregion CheckAuthorization
    if (event is GoogleSignInAuthenticationEventSignIn) {
      _currentUser = event.user;
      debugPrint("User signed in: ${event.user.email}");
      user = event.user;
    } else if (event is GoogleSignInAuthenticationEventSignOut) {
      _currentUser = null;
      debugPrint("User signed out");
      user = null;
    }
  }

  String _handleAuthenticationError(Object e) {
    return e is GoogleSignInException
        ? 'GoogleSignInException ${e.code}: ${e.description}'
        : 'Unknown error: $e';
  }

  GoogleSignInAccount? get currentUser => _currentUser;
}

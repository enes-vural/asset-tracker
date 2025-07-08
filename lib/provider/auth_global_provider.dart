import 'dart:async';
import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:asset_tracker/domain/usecase/auth/google_signin_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';

class AuthGlobalProvider extends ChangeNotifier {
  FirebaseAuthUser? _currentUser;
  StreamSubscription? _authSubscription;
  String? _notificationToken;

  String? _currentUserId;

  AuthGlobalProvider(ref) {
    initCurrentUser(ref);
  }

  void initCurrentUser(ref) async {
    _authSubscription = getIt<IEmailAuthRepository>()
        .getUserStateChanges()
        .listen((event) async {
      _currentUserId = event?.uid;
      _currentUser = FirebaseAuthUser(user: event, idToken: null);
      debugPrint("Current User ID: $_currentUserId");
      notifyListeners();
    });
    await getIt<SocialSignInUseCase>().initializeServices();
  }

  void updateFcmToken(String newToken) {
    _notificationToken = newToken;
    notifyListeners();
  }

  String? get notificationToken => _notificationToken;
  String? get getCurrentUserId => _currentUserId;
  FirebaseAuthUser? get getCurrentUser => _currentUser;
  bool get isUserAuthorized => _currentUser?.user != null ? true : false;

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

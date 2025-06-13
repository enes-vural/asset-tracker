import 'dart:async';
import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';

class AuthGlobalProvider extends ChangeNotifier {
  FirebaseAuthUser? _currentUser;
  StreamSubscription? _authSubscription;
  final StreamController<String?> _currentUserIdStream =
      StreamController.broadcast();
  String? _currentUserId;

  AuthGlobalProvider(ref) {
    initCurrentUser(ref);
  }

  void initCurrentUser(ref) {
    _authSubscription =
        getIt<IAuthRepository>().getUserStateChanges().listen((event) {
      _currentUserIdStream.add(event?.uid);
      _currentUserId = event?.uid;
      _currentUser = FirebaseAuthUser(user: event, idToken: null);
      debugPrint("Current User ID: $_currentUserId");
      notifyListeners();
    });
  }

  Stream<String?> get getCurrentUserStream => _currentUserIdStream.stream;
  String? get getCurrentUserId => _currentUserId;
  FirebaseAuthUser? get getCurrentUser => _currentUser;
  bool get isUserAuthorized => _currentUser?.user != null ? true : false;

  @override
  void dispose() {
    _authSubscription?.cancel();
    _currentUserIdStream.close();
    super.dispose();
  }
}

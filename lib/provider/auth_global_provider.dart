import 'dart:async';
import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGlobalProvider extends ChangeNotifier {
  FirebaseAuthUser? _currentUser;
  StreamSubscription? _authSubscription;
  final StreamController<String?> _currentUserIdStream =
      StreamController.broadcast();
  String? _currentUserId;

  AuthGlobalProvider(Ref ref) {
    initCurrentUser(ref);
  }

  void initCurrentUser(Ref ref) {
    _authSubscription =
        ref.read(authRepositoryProvider).getUserStateChanges().listen((event) {
      _currentUserIdStream.add(event?.uid);
      _currentUserId = event?.uid;
      _currentUser = FirebaseAuthUser(user: event, idToken: null);
      notifyListeners();
    });
  }

  Stream<String?> get getCurrentUserStream => _currentUserIdStream.stream;
  String? get getCurrentUserId => _currentUserId;
  FirebaseAuthUser? get getCurrentUser => _currentUser;
  @override
  void dispose() {
    _authSubscription?.cancel();
    _currentUserIdStream.close();
    super.dispose();
  }
}

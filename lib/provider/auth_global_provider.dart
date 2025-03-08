import 'dart:async';
import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGlobalProvider extends ChangeNotifier {
  FirebaseAuthUser? user;
  StreamSubscription? _authSubscription;
  final StreamController<String?> _currentUserIdStream =
      StreamController.broadcast();
  String? currentUserId;

  AuthGlobalProvider(Ref ref) {
    _initCurrentUser(ref);
  }

  void _initCurrentUser(Ref ref) {
    _authSubscription =
        ref.read(authRepositoryProvider).getUserStateChanges().listen((event) {
      _currentUserIdStream.add(event?.uid);
      currentUserId = event?.uid;
      notifyListeners();
    });
  }

  Stream<String?> get getCurrentUserStream => _currentUserIdStream.stream;
  String? get getCurrentUserId => currentUserId;

  @override
  void dispose() {
    _authSubscription?.cancel();
    _currentUserIdStream.close();
    super.dispose();
  }
}

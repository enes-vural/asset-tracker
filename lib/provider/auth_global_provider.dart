import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGlobalProvider extends ChangeNotifier {
  String? currentUserId;

  void setCurrentUserId(WidgetRef ref) {
    currentUserId = ref.read(authRepositoryProvider).getUserId();
    notifyListeners();
  }
}

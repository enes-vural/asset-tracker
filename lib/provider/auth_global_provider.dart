import 'dart:async';
import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:asset_tracker/domain/usecase/auth/google_signin_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AuthGlobalProvider extends ChangeNotifier {
  FirebaseAuthUser? _currentUser;
  StreamSubscription? _authSubscription;
  String? _notificationToken;
  String? _currentUserId;
  bool _isInitialized = false;

  AuthGlobalProvider(ref) {
    // Hiç bir şey yapma, sadece constructor'ı bitir
    // İlk getter çağrıldığında initialize et
    _initializeWhenReady(ref);
  }

  void _initializeWhenReady(ref) {
    // Widget tree tamamen hazır olana kadar bekle
    Future(() async {
      // Scheduler boşta olana kadar bekle
      while (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
        await Future.delayed(Duration(milliseconds: 1));
      }

      // Bir frame daha bekle
      await WidgetsBinding.instance.endOfFrame;

      if (!_isInitialized) {
        _isInitialized = true;
        await initCurrentUser(ref);
      }
    });
  }

  Future<void> initCurrentUser(ref) async {
    debugPrint("🔥 DEBUG: initCurrentUser BAŞLADI");

    // Önce manuel kontrol et
    final currentUser = FirebaseAuth.instance.currentUser;
    debugPrint("🔥 DEBUG: Manuel currentUser: ${currentUser?.uid}");
    debugPrint("🔥 DEBUG: Manuel user email: ${currentUser?.email}");

    // Eğer user varsa, direkt set et - ama notification'ı ertele
    if (currentUser != null) {
      _currentUserId = currentUser.uid;
      _currentUser = FirebaseAuthUser(user: currentUser, idToken: null);
      debugPrint("🔥 DEBUG: Manuel user set edildi: $_currentUserId");

      // Notification'ı güvenli şekilde ertele
      _deferNotification();
    }

    // Stream listener
    debugPrint("🔥 DEBUG: Stream listener kuruluyor...");
    _authSubscription = getIt<IEmailAuthRepository>()
        .getUserStateChanges()
        .listen((event) async {
      debugPrint("🔥 DEBUG: Stream tetiklendi!");
      debugPrint("🔥 DEBUG: Stream event uid: ${event?.uid}");
      debugPrint("🔥 DEBUG: Stream event email: ${event?.email}");
    
      _currentUserId = event?.uid;
      _currentUser = FirebaseAuthUser(user: event, idToken: null);
      debugPrint("🔥 DEBUG: Stream'den user set edildi: $_currentUserId");

      // Stream'den gelen değişiklikleri de güvenli şekilde notification et
      _deferNotification();
    }, onError: (error) {
      debugPrint("🔥 DEBUG: Stream ERROR: $error");
    });

    debugPrint("🔥 DEBUG: Stream listener kuruldu");

    try {
      await getIt<SocialSignInUseCase>().initializeServices();
      debugPrint("🔥 DEBUG: SocialSignInUseCase initialize tamamlandı");
    } catch (e) {
      debugPrint("🔥 DEBUG: SocialSignInUseCase ERROR: $e");
    }

    debugPrint("🔥 DEBUG: initCurrentUser TAMAMLANDI");
  }

  // Güvenli notification metodu
  void _deferNotification() {
    Future(() {
      if (hasListeners && mounted) {
        notifyListeners();
      }
    });
  }

  // Provider'ın hala aktif olup olmadığını kontrol et
  bool get mounted => hasListeners;

  // IEmailAuthRepository'de de kontrol et:
  Stream<User?> getUserStateChanges() {
    debugPrint("🔥 DEBUG: getUserStateChanges çağrıldı");

    final stream = FirebaseAuth.instance.authStateChanges();

    // Test için manual listen
    stream.listen((user) {
      debugPrint("🔥 DEBUG: authStateChanges tetiklendi: ${user?.uid}");
    });

    return stream;
  }

  void updateFcmToken(String newToken) {
    _notificationToken = newToken;
    _deferNotification(); // Bu da güvenli notification kullanıyor
  }

  // Getters - lazy initialization
  String? get notificationToken {
    return _notificationToken;
  }

  String? get getCurrentUserId {
    return _currentUserId;
  }

  FirebaseAuthUser? get getCurrentUser {
    return _currentUser;
  }

  bool get isUserAuthorized {
    return _currentUser?.user != null;
  }

  @override
  void dispose() {
    debugPrint("🔥 DEBUG: AuthGlobalProvider dispose edildi");
    _authSubscription?.cancel();
    _authSubscription = null;
    super.dispose();
  }
}

import 'dart:async';
import 'package:asset_tracker/application/sync/sync_manager.dart';
import 'package:asset_tracker/core/routers/app_router.gr.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/database/request/save_user_entity.dart';
import 'package:asset_tracker/domain/usecase/database/database_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashViewModel extends ChangeNotifier {
  static DateTime? _lastSyncTime;

  Future<void> init(WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(webSocketProvider.notifier).initializeSocket();
      final authGlobal = ref.watch(authGlobalProvider.notifier);
      final syncUser = ref.read(syncManagerProvider);
      // Önce hızlı kontrolleri yap
      final currentUser = authGlobal.getCurrentUser;
      final String? userId = currentUser?.user?.uid;

      final bool isLoggedIn = _isLoginedBefore(userId);

      // Eğer giriş yapılmamışsa, diğer işlemleri yapma
      if (!isLoggedIn) {
        _navigateHomeOrLogin(context, access: false);
        return;
      }

      // Paralel işlemler için Future listesi
      List<Future> parallelTasks = [];

      // Sync işlemi (throttle ile)
      if (_shouldSync()) {
        parallelTasks.add(_syncWithThrottle(syncUser));
      }

      // Paralel işlemleri başlat
      if (parallelTasks.isNotEmpty) {
        await Future.wait(parallelTasks, eagerError: false);
      }

      // User data kontrolü (sadece gerekirse)
      if (userId != null && currentUser != null) {
        final userDataStatus =
            await _getUserDataWithTimeout(ref, UserUidEntity(userId: userId));

        if (ref.read(appGlobalProvider).getUserData?.userInfoEntity == null) {
          final saveState = await getIt<DatabaseUseCase>().saveUserData(
            SaveUserEntity(
              uid: userId,
              userName: currentUser.email.toString(),
              firstName: currentUser.displayName.toString(),
              lastName: currentUser.displayName.toString(),
            ),
          );
          saveState.fold(
            (failure) {
              debugPrint(failure.message);
              _navigateHomeOrLogin(context, access: false);
              return;
            },
            (success) {
              debugPrint("Use data has been saved in splash view model");
            },
          );
        }

        if (!userDataStatus) {
          _navigateHomeOrLogin(context, access: false);
          return;
        }
      }

      if (userId != null) {
        await getIt<DatabaseUseCase>().saveUserToken(
          UserUidEntity(userId: userId),
          "",
        );
      }

      // Başarılı durumda home'a git
      _navigateHomeOrLogin(context, access: true);
    } catch (e) {
      debugPrint('Splash init error: $e');
      // Hata durumunda login'e yönlendir
      _navigateHomeOrLogin(context, access: false);
    }
  }

  // Sync işlemini throttle ile
  Future<void> _syncWithThrottle(SyncManager syncUser) async {
    try {
      await syncUser.syncOfflineActions().timeout(
        const Duration(seconds: 5), // 10 saniye timeout
        onTimeout: () {
          debugPrint('Sync timeout, continuing without sync');
        },
      );
      _lastSyncTime = DateTime.now();
    } catch (e) {
      debugPrint('Sync error: $e');
    }
  }

  // Sync gerekli mi kontrol et (5 dakika throttle)
  bool _shouldSync() {
    if (_lastSyncTime == null) return true;
    return DateTime.now().difference(_lastSyncTime!) >
        const Duration(minutes: 5);
  }

  // User data timeout ile
  Future<bool> _getUserDataWithTimeout(
      WidgetRef ref, UserUidEntity userEntity) async {
    try {
      final result = await ref
          .read(appGlobalProvider)
          .getLatestUserData(ref, userEntity)
          .timeout(
        const Duration(seconds: 10), // 8 saniye timeout
        onTimeout: () {
          debugPrint('GetLatestUserData timeout');
          return false;
        },
      );
      return result;
    } catch (e) {
      debugPrint('GetLatestUserData error: $e');
      return false;
    }
  }

  bool _isLoginedBefore(String? uid) => (uid != null && uid.isNotEmpty);

  void _navigateHomeOrLogin(BuildContext context, {bool access = false}) {
    // Duplicate navigation önleme
    //if (ModalRoute.of(context)?.isCurrent != true) return;

    Routers.instance.replaceAll(context, const MenuRoute());
  }

  // Cache temizleme metodu (isteğe bağlı)
  static void clearCache() {
    _lastSyncTime = null;
  }
}

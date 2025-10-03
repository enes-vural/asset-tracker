import 'dart:async';
import 'dart:io';
import 'package:asset_tracker/application/sync/sync_manager.dart';
import 'package:asset_tracker/core/routers/app_router.gr.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/database/request/save_user_entity.dart';
import 'package:asset_tracker/domain/usecase/database/database_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upgrader/upgrader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:version/version.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashViewModel extends ChangeNotifier {
  static DateTime? _lastSyncTime;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  String versionURL(bool isAndroid) {
    if (isAndroid) {
      return "https://raw.githubusercontent.com/enes-vural/asset-tracker/main/updates/android_appcast.xml";
    } else {
      return "https://raw.githubusercontent.com/enes-vural/asset-tracker/main/updates/ios_appcast.xml";
    }
  }

  Future<dynamic> checkAppVersion(BuildContext context) async {
    await Upgrader.clearSavedSettings();
    String versionUrl =
        versionURL(Platform.isAndroid); // Platform'a göre URL seçimi

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      debugPrint("=== PACKAGE INFO DEBUG ===");
      debugPrint("Package name: ${packageInfo.packageName}");
      debugPrint("Version: ${packageInfo.version}");
      debugPrint("Build number: ${packageInfo.buildNumber}");
      debugPrint("App name: ${packageInfo.appName}");
    } catch (e) {
      debugPrint("PackageInfo error: $e");
    }

    final upgrader = Upgrader(
      debugDisplayAlways: false, // Debug için true yapın
      debugDisplayOnce: false,
      debugLogging: true,
      storeController: UpgraderStoreController(
        onAndroid: () => UpgraderAppcastStore(appcastURL: versionUrl),
        oniOS: () => UpgraderAppcastStore(appcastURL: versionUrl),
      ),
    );

    try {
      // ÖNEMLİ: Önce initialize etmek gerekiyor
      await upgrader.initialize();

      // Version bilgilerini al
      final versionInfo = upgrader.versionInfo;
      debugPrint("=== VERSION INFO DEBUG ===");
      debugPrint("Version info: $versionInfo");
      debugPrint("App store version: ${versionInfo?.appStoreVersion}");
      debugPrint("Installed version: ${versionInfo?.installedVersion}");

      // Şimdi kontrol et
      final shouldUpdate = upgrader.shouldDisplayUpgrade();
      debugPrint("Should update: $shouldUpdate");

      if (shouldUpdate) {
        if (upgrader.blocked()) {
          debugPrint("Update required, navigating to update page...");
          if (context.mounted) {
            Routers.instance.pushAndRemoveUntil(context, const UpdateRoute());
          }
          return true;
        } else {
          debugPrint("Optional update");
          return false;
        }
      } else {
        debugPrint("No need to update.");
        return false;
      }
    } catch (e) {
      debugPrint("Upgrade check error: $e");
      // Hata durumunda false döndür (normal flow devam etsin)
      return false;
    }
  }

  Future<void> _initializeWebSocket(WidgetRef ref) async {
    try {
      await ref.read(webSocketProvider.notifier).initializeSocket();
      debugPrint('WebSocket initialized');
    } catch (e) {
      debugPrint('WebSocket initialization error: $e');
    }
  }

  Future<void> init(WidgetRef ref, BuildContext context) async {
    try {
      final updateStatus = await checkAppVersion(context);
      if (updateStatus) return;

      await _initializeWebSocket(ref);

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

      // 5. NON-KRİTİK: Arka plan işlemleri (dispose kontrolü ile)
      _executeBackgroundTasks(ref, userId, currentUser);

      _navigateHomeOrLogin(context, access: true);

      // Paralel işlemler için Future listesi
    } catch (e) {
      debugPrint('Splash init error: $e');
      // Hata durumunda login'e yönlendir
      _navigateHomeOrLogin(context, access: false);
    }
  }

  void _executeBackgroundTasks(
    WidgetRef ref,
    String? userId,
    dynamic currentUser,
  ) {
    // Future.microtask ile sonraki frame'de çalıştır
    Future.microtask(() async {
      try {
        // Sync işlemi
        if (_shouldSync()) {
          await _syncInBackground(ref);
        }

        // User data işlemleri
        if (userId != null && currentUser != null && !_isDisposed) {
          await _handleUserDataInBackground(ref, userId, currentUser);
        }

        // Token kaydetme
        if (userId != null && !_isDisposed) {
          await _saveUserTokenInBackground(userId);
        }
      } catch (e) {
        debugPrint('Background tasks error: $e');
      }
    });
  }

  // Arka planda sync (dispose kontrolü ile)
  Future<void> _syncInBackground(WidgetRef ref) async {
    try {
      final syncUser = ref.read(syncManagerProvider);
      await syncUser.syncOfflineActions().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Sync timeout in background');
        },
      );
      _lastSyncTime = DateTime.now();
      debugPrint('Background sync completed');
    } catch (e) {
      debugPrint('Background sync error: $e');
    }
  }

  Future<void> _saveUserTokenInBackground(String userId) async {
    try {
      if (_isDisposed) return;

      await getIt<DatabaseUseCase>().saveUserToken(
        UserUidEntity(userId: userId),
        "",
      );
      debugPrint('User token saved in background');
    } catch (e) {
      debugPrint('Background token save error: $e');
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

  Future<void> _handleUserDataInBackground(
    WidgetRef ref,
    String userId,
    dynamic currentUser,
  ) async {
    try {
      if (_isDisposed) return;

      final userDataStatus = await ref
          .read(appGlobalProvider)
          .getLatestUserData(ref, UserUidEntity(userId: userId))
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('GetLatestUserData timeout in background');
          return false;
        },
      );

      if (_isDisposed) return;

      // User data yoksa kaydet
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
          (failure) => debugPrint('Save user data failed: ${failure.message}'),
          (success) => debugPrint('User data saved in background'),
        );
      }

      debugPrint('Background user data handling completed');
    } catch (e) {
      debugPrint('Background user data error: $e');
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

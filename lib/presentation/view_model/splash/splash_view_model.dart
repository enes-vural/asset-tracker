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

  Future<Version> getOsVersion() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return Version(androidInfo.version.sdkInt, 0, 0); // major = sdkInt
    } else if (Platform.isIOS) {
      final deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      final major = int.parse(iosInfo.systemVersion.split(".")[0]);
      final minor = iosInfo.systemVersion.split(".").length > 1
          ? int.parse(iosInfo.systemVersion.split(".")[1])
          : 0;
      final patch = iosInfo.systemVersion.split(".").length > 2
          ? int.parse(iosInfo.systemVersion.split(".")[2])
          : 0;
      return Version(major, minor, patch);
    } else {
      return Version(0, 0, 0);
    }
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
      final versionInfo = await upgrader.versionInfo;
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

  Future<void> init(WidgetRef ref, BuildContext context) async {
    try {
      final updateStatus = await checkAppVersion(context);
      if (updateStatus) {
        return;
      }
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

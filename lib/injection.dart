// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:asset_tracker/application/sync/sync_manager.dart';
import 'package:asset_tracker/data/repository/auth/base/base_auth_repository.dart';
import 'package:asset_tracker/data/repository/auth/firebase_auth_email_repository.dart';
import 'package:asset_tracker/data/repository/auth/social_sign_in_repository.dart';
import 'package:asset_tracker/data/repository/cache/cache_repository.dart';
import 'package:asset_tracker/data/repository/database/firestore/firestore_repository.dart';
import 'package:asset_tracker/data/repository/messaging/firebase_messaging_repository.dart';
import 'package:asset_tracker/data/repository/web/web_socket_repository.dart';
import 'package:asset_tracker/data/service/cache/hive_cache_service.dart';
import 'package:asset_tracker/data/service/cache/icache_service.dart';
import 'package:asset_tracker/data/service/remote/auth/firebase_apple_sign_in_service.dart';
import 'package:asset_tracker/data/service/remote/auth/firebase_auth_service.dart';
import 'package:asset_tracker/data/service/remote/auth/google_sign_in_service.dart';
import 'package:asset_tracker/data/service/remote/auth/ifirebase_auth_service.dart';
import 'package:asset_tracker/data/service/remote/auth/isign_in_service.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/firestore_service.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/ifirestore_service.dart';
import 'package:asset_tracker/data/service/remote/messaging/firebase_messaging_service.dart';
import 'package:asset_tracker/data/service/remote/messaging/imessaging_service.dart';
import 'package:asset_tracker/data/service/remote/web/iweb_socket_service.dart';
import 'package:asset_tracker/data/service/remote/web/web_socket_service.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:asset_tracker/domain/repository/cache/icache_repository.dart';
import 'package:asset_tracker/domain/repository/database/firestore/ifirestore_repository.dart';
import 'package:asset_tracker/domain/repository/messaging/imessaging_repository.dart';
import 'package:asset_tracker/domain/repository/web/iweb_socket_repository.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:asset_tracker/domain/usecase/auth/google_signin_use_case.dart';
import 'package:asset_tracker/domain/usecase/cache/cache_use_case.dart';
import 'package:asset_tracker/domain/usecase/database/database_use_case.dart';
import 'package:asset_tracker/domain/usecase/messaging/messaging_use_case.dart';
import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:asset_tracker/presentation/view_model/auth/auth_view_model.dart';
import 'package:asset_tracker/presentation/view_model/home/alarm/alarm_view_model.dart';
import 'package:asset_tracker/presentation/view_model/home/dashboard/dashboard_view_model.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';
import 'package:asset_tracker/presentation/view_model/home/trade/trade_view_model.dart';
import 'package:asset_tracker/presentation/view_model/settings/settings_view_model.dart';
import 'package:asset_tracker/presentation/view_model/splash/splash_view_model.dart';
import 'package:asset_tracker/provider/app_global_provider.dart';
import 'package:asset_tracker/provider/auth_global_provider.dart';
import 'package:asset_tracker/provider/web_socket_notifier.dart';
import 'package:asset_tracker/provider/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ==================== SERVICES ====================
  getIt.registerLazySingleton<ICacheService>(() => HiveCacheService());

  getIt.registerLazySingleton<IMessagingService>(
      () => FirebaseMessagingService(instance: FirebaseMessaging.instance));

  getIt.registerLazySingleton<ISignInService>(
    () => GoogleSignInService(GoogleSignIn.instance),
    instanceName: 'google',
  );

  getIt.registerLazySingleton<IFirebaseAuthService>(
      () => FirebaseAuthService(authService: FirebaseAuth.instance));

  getIt.registerLazySingleton<ISignInService>(
    () => FirebaseAppleSignInService(
      FirebaseAuth.instance,
      AppleAuthProvider(),
    ),
    instanceName: 'apple',
  );

  getIt.registerLazySingleton<IWebSocketService>(() => WebSocketService());

  getIt.registerLazySingleton<IFirestoreService>(
      () => FirestoreService(
      instance: FirebaseFirestore.instance,
      functions: FirebaseFunctions.instance));

  // ==================== REPOSITORIES ====================
  getIt.registerLazySingleton<ICacheRepository>(
      () => CacheRepository(getIt<ICacheService>()));

  getIt.registerLazySingleton<BaseAuthRepository>(
      () => BaseAuthRepository(authService: getIt<IFirebaseAuthService>()));

  getIt.registerLazySingleton<IMessagingRepository>(() =>
      FirebaseMessagingRepository(
          messagingService: getIt<IMessagingService>()));

  getIt.registerLazySingleton<ISocialAuthRepository>(() => SocialAuthRepository(
        getIt<ISignInService>(instanceName: 'google'),
        getIt<ISignInService>(instanceName: 'apple'),
        getIt<IFirebaseAuthService>(),
        getIt<BaseAuthRepository>(),
      ));

  getIt.registerLazySingleton<IEmailAuthRepository>(
      () => FirebaseAuthEmailRepository(
            baseAuthRepository: getIt<BaseAuthRepository>(),
            authService: getIt<IFirebaseAuthService>(),
          ));

  getIt.registerLazySingleton<IWebSocketRepository>(
      () => WebSocketRepository(socketService: getIt<IWebSocketService>()));

  getIt.registerLazySingleton<IFirestoreRepository>(
      () => FirestoreRepository(firestoreService: getIt<IFirestoreService>()));

  // ==================== USE CASES ====================
  getIt.registerLazySingleton<CacheUseCase>(
      () => CacheUseCase(cacheRepository: getIt<ICacheRepository>()));

  getIt.registerLazySingleton<AuthUseCase>(
      () => AuthUseCase(getIt<IEmailAuthRepository>()));

  getIt.registerLazySingleton<NotificationUseCase>(
      () => NotificationUseCase(getIt<IMessagingRepository>()));

  getIt.registerLazySingleton<SocialSignInUseCase>(
      () => SocialSignInUseCase(getIt<ISocialAuthRepository>()));

  getIt.registerLazySingleton<DatabaseUseCase>(() =>
      DatabaseUseCase(firestoreRepository: getIt<IFirestoreRepository>()));

  getIt.registerLazySingleton<GetSocketStreamUseCase>(
      () => GetSocketStreamUseCase(getIt<IWebSocketRepository>()));

  // ==================== MANAGERS ====================
  getIt.registerLazySingleton<SyncManager>(() => SyncManager());
}

final appGlobalProvider = ChangeNotifierProvider<AppGlobalProvider>((ref) {
  return AppGlobalProvider();
});

final authGlobalProvider = ChangeNotifierProvider<AuthGlobalProvider>((ref) {
  return AuthGlobalProvider(ref);
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  return SyncManager();
});

final appThemeProvider =
    AsyncNotifierProvider<AppThemeNotifier, AppThemeState>(() {
  return AppThemeNotifier(cacheUseCase: getIt<CacheUseCase>());
});

//Riverpod ref.watch() ile sadece gerektiği ve değiştiği yerde çağırdığı için aslında bir nevi
//lazy injection görevi görüyor.

//bağımlılığı olmayan en dış service katmanın bileşenini riverpod ile aktif etmek yerine direkt olarak instance olarak aldık

//Firebase Auth Service 'in bağımlılıklarını enjekte eder.
//Dependency = FirebaseAuth.instance (from firebase_auth package)
//Şimdilik mock data üzerinden gideceğimiz için atama yapmaya gerek yok.
// final IAuthService mockAuthServiceInstance = MockAuthService();

//-----------------------------------------------
//We changed the service provider with mock service in repository layer.
//burası açıldığı anda mock service ile authentication işlemlerini yapacak.
// final authRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
//   return FirebaseAuthRepository(authService: mockAuthServiceInstance);
// });

//Burası açıldığı anda Firebase ile authentication işlemlerini yapacak.
//------------------ VIEW MODEL PROVIDERS ------------------

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  return AuthViewModel(
      authUseCase: getIt<AuthUseCase>(),
      socialSignInUseCase: getIt<SocialSignInUseCase>());
});

final splashViewModelProvider = ChangeNotifierProvider<SplashViewModel>((ref) {
  return SplashViewModel();
});

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
  return HomeViewModel(getSocketStreamUseCase: getIt<GetSocketStreamUseCase>());
});

final tradeViewModelProvider = ChangeNotifierProvider<TradeViewModel>((ref) {
  return TradeViewModel();
});

final dashboardViewModelProvider =
    ChangeNotifierProvider<DashboardViewModel>((ref) {
  return DashboardViewModel();
});

final settingsViewModelProvider =
    ChangeNotifierProvider<SettingsViewModel>((ref) {
  return SettingsViewModel(
    getIt<AuthUseCase>(),
    ref.read(appGlobalProvider),
    ref.read(authGlobalProvider),
    getIt<DatabaseUseCase>(),
    getIt<CacheUseCase>(),
  );
});

final webSocketProvider =
    StateNotifierProvider<WebSocketNotifier, WebSocketState>((ref) {
  return WebSocketNotifier();
});

final alarmViewModelProvider = ChangeNotifierProvider<AlarmViewModel>((ref) {
  return AlarmViewModel();
});
//-------------------CUSTOM PROVIDERS-------------------
//test@gmail.com

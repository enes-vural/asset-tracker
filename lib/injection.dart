// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:asset_tracker/application/sync/sync_manager.dart';
import 'package:asset_tracker/data/repository/auth/auth_repository.dart';
import 'package:asset_tracker/data/repository/cache/cache_repository.dart';
import 'package:asset_tracker/data/repository/database/firestore/firestore_repository.dart';
import 'package:asset_tracker/data/repository/web/web_socket_repository.dart';
import 'package:asset_tracker/data/service/cache/hive_cache_service.dart';
import 'package:asset_tracker/data/service/cache/icache_service.dart';
import 'package:asset_tracker/data/service/remote/auth/firebase_auth_service.dart';
import 'package:asset_tracker/data/service/remote/auth/ifirebase_auth_service.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/firestore_service.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/ifirestore_service.dart';
import 'package:asset_tracker/data/service/remote/web/iweb_socket_service.dart';
import 'package:asset_tracker/data/service/remote/web/web_socket_service.dart';
import 'package:asset_tracker/domain/repository/cache/icache_repository.dart';
import 'package:asset_tracker/domain/repository/database/firestore/ifirestore_repository.dart';
import 'package:asset_tracker/domain/repository/web/iweb_socket_repository.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:asset_tracker/domain/usecase/cache/cache_use_case.dart';
import 'package:asset_tracker/domain/usecase/database/buy_currency_use_case.dart';
import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:asset_tracker/presentation/view_model/auth/auth_view_model.dart';
import 'package:asset_tracker/presentation/view_model/home/dashboard/dashboard_view_model.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';
import 'package:asset_tracker/presentation/view_model/home/trade/trade_view_model.dart';
import 'package:asset_tracker/presentation/view_model/splash/splash_view_model.dart';
import 'package:asset_tracker/provider/app_global_provider.dart';
import 'package:asset_tracker/provider/auth_global_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appGlobalProvider = ChangeNotifierProvider<AppGlobalProvider>((ref) {
  return AppGlobalProvider();
});

final authGlobalProvider = ChangeNotifierProvider<AuthGlobalProvider>((ref) {
  return AuthGlobalProvider(ref);
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  return SyncManager(ref.read);
});

//Riverpod ref.watch() ile sadece gerektiği ve değiştiği yerde çağırdığı için aslında bir nevi
//lazy injection görevi görüyor.

//bağımlılığı olmayan en dış service katmanın bileşenini riverpod ile aktif etmek yerine direkt olarak instance olarak aldık

//Firebase Auth Service 'in bağımlılıklarını enjekte eder.
//Dependency = FirebaseAuth.instance (from firebase_auth package)
//Şimdilik mock data üzerinden gideceğimiz için atama yapmaya gerek yok.
final IFirebaseAuthService authServiceInstance =
    FirebaseAuthService(authService: FirebaseAuth.instance);

// final IAuthService mockAuthServiceInstance = MockAuthService();

final IWebSocketService webSocketService = WebSocketService();

final IFirestoreService firestoreService = FirestoreService(
  instance: FirebaseFirestore.instance,
);

final ICacheService hiveCacheService = HiveCacheService();

//-----------------------------------------------
//We changed the service provider with mock service in repository layer.
//burası açıldığı anda mock service ile authentication işlemlerini yapacak.
// final authRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
//   return FirebaseAuthRepository(authService: mockAuthServiceInstance);
// });

//Burası açıldığı anda Firebase ile authentication işlemlerini yapacak.
final authRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
  return FirebaseAuthRepository(authService: authServiceInstance);
});
//-----------------------------------------------

final webRepositoryProvider = Provider<IWebSocketRepository>((ref) {
  return WebSocketRepository(socketService: webSocketService);
});

final firestoreRepositoryProvider = Provider<IFirestoreRepository>((ref) {
  return FirestoreRepository(firestoreService: firestoreService);
});

final cacheRepositoryProvider = Provider<ICacheRepository>((ref) {
  return CacheRepository(hiveCacheService);
});

//------------------ USE CASE PROVIDERS ------------------

final databaseUseCaseProvider = Provider<DatabaseUseCase>((ref) {
  final _firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return DatabaseUseCase(firestoreRepository: _firestoreRepository);
});

//multiple usage of same repository instance,.
//make here single one shared instance.

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final _authRepositoryProvider = ref.watch(authRepositoryProvider);
  return SignInUseCase(_authRepositoryProvider);
});

final getSocketStreamUseCaseProvider = Provider<GetSocketStreamUseCase>((ref) {
  final _webRepository = ref.watch(webRepositoryProvider);
  return GetSocketStreamUseCase(_webRepository);
});

final cacheUseCaseProvider = Provider<CacheUseCase>((ref) {
  final _cacheRepository = ref.watch(cacheRepositoryProvider);
  return CacheUseCase(cacheRepository: _cacheRepository);
});

//------------------ VIEW MODEL PROVIDERS ------------------

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  final _signInUseCaseProvider = ref.watch(signInUseCaseProvider);
  return AuthViewModel(signInUseCase: _signInUseCaseProvider);
});

final splashViewModelProvider = ChangeNotifierProvider<SplashViewModel>((ref) {
  return SplashViewModel();
});

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
  final socketUseCase = ref.watch(getSocketStreamUseCaseProvider);
  return HomeViewModel(getSocketStreamUseCase: socketUseCase);
});

final tradeViewModelProvider = ChangeNotifierProvider<TradeViewModel>((ref) {
  return TradeViewModel();
});

final dashboardViewModelProvider =
    ChangeNotifierProvider<DashboardViewModel>((ref) {
  return DashboardViewModel();
});

//-------------------CUSTOM PROVIDERS-------------------
//test@gmail.com

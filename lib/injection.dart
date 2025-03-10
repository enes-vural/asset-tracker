// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:asset_tracker/data/repository/auth/auth_repository.dart';
import 'package:asset_tracker/data/repository/database/firestore/firestore_repository.dart';
import 'package:asset_tracker/data/repository/web/web_socket_repository.dart';
import 'package:asset_tracker/data/service/remote/auth/firebase_auth_service.dart';
import 'package:asset_tracker/data/service/remote/auth/ifirebase_auth_service.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/firestore_service.dart';
import 'package:asset_tracker/data/service/remote/database/firestore/ifirestore_service.dart';
import 'package:asset_tracker/data/service/remote/web/iweb_socket_service.dart';
import 'package:asset_tracker/data/service/remote/web/web_socket_service.dart';
import 'package:asset_tracker/domain/repository/web/iweb_socket_repository.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:asset_tracker/domain/usecase/database/buy_currency_use_case.dart';
import 'package:asset_tracker/domain/usecase/database/get_currency_code_use_case.dart';
import 'package:asset_tracker/domain/usecase/database/get_user_data_use_case.dart';
import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:asset_tracker/presentation/view_model/auth/auth_view_model.dart';
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

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(firestoreService: firestoreService);
});

//------------------ USE CASE PROVIDERS ------------------

final getAssetCodesUseCaseProvider = Provider<GetCurrencyCodeUseCase>((ref) {
  final _firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return GetCurrencyCodeUseCase(firestoreRepository: _firestoreRepository);
});

//multiple usage of same repository instance,.
//make here single one shared instance.

final buyCurrencyUseCaseProvider = Provider<BuyCurrencyUseCase>((ref) {
  final _firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return BuyCurrencyUseCase(firestoreRepository: _firestoreRepository);
});

final getUserDataUseCaseProvider = Provider<GetUserDataUseCase>((ref) {
  final _firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return GetUserDataUseCase(firestoreRepository: _firestoreRepository);
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final _authRepositoryProvider = ref.watch(authRepositoryProvider);
  return SignInUseCase(_authRepositoryProvider);
});

final getSocketStreamUseCaseProvider = Provider<GetSocketStreamUseCase>((ref) {
  final _webRepository = ref.watch(webRepositoryProvider);
  return GetSocketStreamUseCase(_webRepository);
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
//test@gmail.com

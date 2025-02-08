// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:asset_tracker/data/repository/auth/auth_repository.dart';
import 'package:asset_tracker/data/repository/web/web_socket_repository.dart';
import 'package:asset_tracker/data/service/remote/auth/firebase_auth_service.dart';
import 'package:asset_tracker/data/service/remote/auth/iauth_service.dart';
import 'package:asset_tracker/data/service/remote/auth/ifirebase_auth_service.dart';
import 'package:asset_tracker/data/service/remote/auth/mock/mock_auth_service.dart';
import 'package:asset_tracker/data/service/remote/web/iweb_socket_service.dart';
import 'package:asset_tracker/data/service/remote/web/web_socket_service.dart';
import 'package:asset_tracker/domain/repository/web/iweb_socket_repository.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:asset_tracker/presentation/view_model/auth/auth_view_model.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Riverpod ref.watch() ile sadece gerektiği ve değiştiği yerde çağırdığı için aslında bir nevi
//lazy injection görevi görüyor.

//bağımlılığı olmayan en dış service katmanın bileşenini riverpod ile aktif etmek yerine direkt olarak instance olarak aldık

final IFirebaseAuthService authServiceInstance =
    FirebaseAuthService(authService: FirebaseAuth.instance);

final IAuthService mockAuthServiceInstance = MockAuthService();

final IWebSocketService webSocketService = WebSocketService();

//-----------------------------------------------
//We changed the service provider with mock service in repository layer.
//burası açıldığı anda mock service ile authentication işlemlerini yapacak.
final authRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
  return FirebaseAuthRepository(authService: mockAuthServiceInstance);
});

//Burası açıldığı anda Firebase ile authentication işlemlerini yapacak.
// final authRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
//   return FirebaseAuthRepository(authService: authServiceInstance);
// });
//-----------------------------------------------

final webRepositoryProvider = Provider<IWebSocketRepository>((ref) {
  return WebSocketRepository(socketService: webSocketService);
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final _authRepositoryProvider = ref.watch(authRepositoryProvider);
  return SignInUseCase(_authRepositoryProvider);
});

final getSocketStreamUseCaseProvider = Provider<GetSocketStreamUseCase>((ref) {
  final _webRepository = ref.watch(webRepositoryProvider);
  return GetSocketStreamUseCase(_webRepository);
});

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  final _signInUseCaseProvider = ref.watch(signInUseCaseProvider);
  return AuthViewModel(signInUseCase: _signInUseCaseProvider);
});

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
  final socketUseCase = ref.watch(getSocketStreamUseCaseProvider);
  return HomeViewModel(getSocketStreamUseCase: socketUseCase);
});

//test@gmail.com

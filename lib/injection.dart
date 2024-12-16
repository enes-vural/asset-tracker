// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:asset_tracker/data/repository/auth/auth_repository.dart';
import 'package:asset_tracker/data/service/remote/auth/auth_service.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:asset_tracker/presentation/view_model/auth/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Riverpod ref.watch() ile sadece gerektiği ve değiştiği yerde çağırdığı için aslında bir nevi
//lazy injection görevi görüyor.

final authServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final _authServiceProvider = ref.watch(authServiceProvider);
  return AuthRepository(authService: _authServiceProvider);
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final _authRepositoryProvider = ref.watch(authRepositoryProvider);
  return SignInUseCase(_authRepositoryProvider);
});

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  final _signInUseCaseProvider = ref.watch(signInUseCaseProvider);
  return AuthViewModel(signInUseCase: _signInUseCaseProvider);
});

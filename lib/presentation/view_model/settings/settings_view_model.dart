import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:asset_tracker/provider/app_global_provider.dart';
import 'package:asset_tracker/provider/auth_global_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsViewModel extends ChangeNotifier {
  final SignInUseCase signInUseCase;
  final AppGlobalProvider appGlobalProvider;
  final AuthGlobalProvider authGlobalProvider;

  SettingsViewModel(
    this.signInUseCase,
    this.appGlobalProvider,
    this.authGlobalProvider,
  );

  Future<void> signOut(WidgetRef ref, BuildContext context) async {
    await signInUseCase.signOut();
    await appGlobalProvider.clearData();
    //clear old routes before pushing new route
    //Routers.instance.replaceAll(context, const LoginRoute());
    //Routers.instance.pushAndRemoveUntil(context, const LoginRoute());
    notifyListeners();
  }

  bool get isAuthorized => authGlobalProvider.isUserAuthorized;
}

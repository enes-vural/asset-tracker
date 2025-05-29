// ignore_for_file: use_build_context_synchronously

import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/provider/app_global_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashViewModel extends ChangeNotifier {

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  Future<void> startAnimation(tickerThis) async {
    // Animasyon controller'larını başlat
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: tickerThis,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: tickerThis,
    );

    // Animasyonları tanımla
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Animasyonları başlat
      _fadeController.forward();
      Future.delayed(const Duration(milliseconds: 150), () {
        _scaleController.forward();
      });
    });
  }

  void disposeAnimation() {
    _fadeController.dispose();
    _scaleController.dispose();
  }

  Future<void> init(WidgetRef ref, BuildContext context) async {
    //app global provider
    final appGlobal = ref.read(appGlobalProvider.notifier);
    //auth global provider
    final authGlobal = ref.read(authGlobalProvider.notifier);
    //get user data usecase provider
    // final getUserData = ref.read(getUserDataUseCaseProvider);

    final syncUser = ref.read(syncManagerProvider);

    //avoid multiple read operations in firebase in initailize
    (!_isAssetsLoaded(appGlobal))
        ? await appGlobal.getCurrencyList(ref)
        : false;

    //get userId from authGlobal
    String? userId = authGlobal.getCurrentUserId;

    await syncUser.syncOfflineActions();
    //if user is not logined in or assets are not loaded, navigate to login page
    if (!(_isLoginedBefore(userId) && _isAssetsLoaded(appGlobal))) {
      _navigateHomeOrLogin(context, access: false);
      return;
    }

    final userDataStatus = await ref.read(appGlobalProvider).getLatestUserData(
        ref, UserUidEntity(userId: userId ?? DefaultLocalStrings.emptyText));

    if (userDataStatus == false) {
      _navigateHomeOrLogin(context, access: false);
      return;
    } else {
      //if user is logined in and assets are loaded, navigate to home page
      _navigateHomeOrLogin(context, access: true);
    }
  }

  //check if user is logined in
  bool _isLoginedBefore(String? uid) => (uid != null && uid.isNotEmpty);

  //check if assets are loaded
  bool _isAssetsLoaded(AppGlobalProvider appGlobal) =>
      appGlobal.assetCodes.isNotEmpty;

  //navigate to home or login page
  void _navigateHomeOrLogin(BuildContext context, {bool access = false}) =>
      Routers.instance.pushReplaceNamed(
          context, access ? Routers.homePath : Routers.loginPath);
}

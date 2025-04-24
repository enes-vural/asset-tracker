// ignore_for_file: use_build_context_synchronously

import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/provider/app_global_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashViewModel extends ChangeNotifier {
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

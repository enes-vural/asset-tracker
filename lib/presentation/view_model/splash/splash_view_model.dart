import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;
    //notifyListeners();
  }

  Future<void> init(WidgetRef ref, BuildContext context) async {
    final results = await Future.wait(
      [
        ref.read(authGlobalProvider.notifier).getCurrentUserStream.first,
        ref.read(appGlobalProvider.notifier).getCurrencyList(ref),
      ],
    );
    final String uid = results[0] as String;
    final _ = results[1];

    if (_checkUserLoggedIn(uid) && _checkAssetCodesLoaded(ref)) {
      setIsLoading(false);
      debugPrint("User is logged in and all data loaded");
      _canUserNavigateHome(context, replace: true);
    } else {
      setIsLoading(false);
      debugPrint("User is not logged in or data not loaded");
      _canUserNavigateHome(context, replace: false);
    }
  }

  bool _checkUserLoggedIn(String? uid) {
    if (uid != null && uid.isNotEmpty) {
      debugPrint("User is logged in");
      return true;
    }
    return false;
  }

  bool _checkAssetCodesLoaded(WidgetRef ref) {
    if (ref.read(appGlobalProvider.notifier).assetCodes.isNotEmpty) {
      debugPrint("All data loaded");
      return true;
    }
    return false;
  }

  void _canUserNavigateHome(BuildContext context, {bool replace = false}) {
    if (replace) {
      Routers.instance.pushReplaceNamed(context, Routers.homePath);
    } else {
      Routers.instance.pushReplaceNamed(context, Routers.loginPath);
    }
  }
}

import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> init(WidgetRef ref) async {
    await ref.read(appGlobalProvider.notifier).getCurrencyList(ref).then((_) {
      if (ref.read(appGlobalProvider).assetCodes.isNotEmpty) {
        debugPrint("All data loaded");
        setIsLoading(false);
        return;
      } else {
        debugPrint("Data is empty");
        setIsLoading(true);
      }
    });
  }

  void navigateToLogin(BuildContext context) {
    Routers.instance.pushReplaceNamed(context, Routers.loginPath);
  }
}

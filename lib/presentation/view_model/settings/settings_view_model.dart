import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsViewModel extends ChangeNotifier {
  Future<void> signOut(WidgetRef ref, BuildContext context) async {
    await ref.read(signInUseCaseProvider).signOut();
    await ref.read(appGlobalProvider.notifier).clearData();
    //clear old routes before pushing new route
    //Routers.instance.replaceAll(context, const LoginRoute());
    //Routers.instance.pushAndRemoveUntil(context, const LoginRoute());
    notifyListeners();
  }
}

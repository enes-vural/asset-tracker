import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class EasyDialog {
  static void showProcessingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Kullanıcının dialog'u dışarı tıklayarak kapatmasını engeller
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(LocaleKeys.app_process.tr()),
          content: const CupertinoActivityIndicator(), // Yükleniyor simgesi
          actions: [
            CupertinoDialogAction(
              onPressed: () {},
              child: Text(LocaleKeys.app_pleaseWait.tr()),
            ),
          ],
        );
      },
    );
  }

  static void hideProcessingDialog(BuildContext context) {
    Navigator.of(context).pop(); // Dialog'u kapatır
  }

  static void showDialogOnProcess(
    BuildContext context,
    WidgetRef ref,
    ChangeNotifierProvider<dynamic> viewModel,
  ) {
    return ref.listen<bool>(
      viewModel.select((vm) => vm.canPop),
      (previous, next) {
        if (previous == next) return;
        if (next) {
          hideProcessingDialog(context);
        } else {
          showProcessingDialog(context);
        }
      },
    );
  }
}

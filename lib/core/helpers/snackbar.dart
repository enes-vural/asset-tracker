import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:flutter/material.dart';

final class EasySnackBar {
  static void show(BuildContext context, String label, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(label),
      //backgroundColor: DefaultColorPalette.customGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(AppSize.largeRadius),
      ),
      backgroundColor:
          isError ? DefaultColorPalette.errorRed : DefaultColorPalette.mainBlue,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ));
  }
}

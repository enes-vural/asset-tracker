import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:flutter/material.dart';

final class EasySnackBar {
  static void show(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(label),
      //backgroundColor: DefaultColorPalette.customGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(AppSize.largeRadius),
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ));
  }
}

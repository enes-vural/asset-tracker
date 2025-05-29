import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:flutter/material.dart';

final class EasySnackBar {
  static void show(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(label),
      backgroundColor: DefaultColorPalette.customGrey,
      duration: const Duration(seconds: 1),
    ));
  }
}

import 'package:flutter/material.dart';

final class EasySnackBar {
  static void show(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(label),
      duration: const Duration(seconds: 1),
    ));
  }
}

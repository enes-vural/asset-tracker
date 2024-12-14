import 'package:flutter/material.dart';

mixin SnackbarMixin on BuildContext {
  void showSnackBar(String label) =>
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(label)));
}

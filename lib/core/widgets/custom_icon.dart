import 'package:flutter/material.dart';

class CustomIcon extends Icon {
  const CustomIcon(super.icon, {super.key});

  /// < icon
  const CustomIcon.modernBackIcon({super.key})
      : super(Icons.arrow_back_ios_new_rounded);

  /// <- icon
  const CustomIcon.defaultBackIcon({super.key}) : super(Icons.arrow_back);
}

import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:flutter/material.dart';

class CustomIcon extends Icon {
  const CustomIcon(super.icon, {super.key});

  /// < icon
  const CustomIcon.modernBackIcon({super.key})
      : super(Icons.arrow_back_ios_new_rounded);

  /// <- icon
  const CustomIcon.defaultBackIcon({super.key}) : super(Icons.arrow_back);

  const CustomIcon.defaultCalendar({super.key}) : super(Icons.calendar_today);

  const CustomIcon.dollarIcon({super.key})
      : super(Icons.attach_money_rounded,
            color: DefaultColorPalette.vanillaGreen);
}

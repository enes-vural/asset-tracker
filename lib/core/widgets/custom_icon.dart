import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:flutter/material.dart';

class CustomIcon extends Icon {
  const CustomIcon(super.icon, {super.key});

  /// < icon
  const CustomIcon.modernBackIcon({super.key})
      : super(IconDataConstants.back, color: DefaultColorPalette.vanillaBlack);

  /// <- icon
  const CustomIcon.defaultBackIcon({super.key}) : super(IconDataConstants.back);

  const CustomIcon.defaultCalendar({super.key})
      : super(IconDataConstants.calendar);

  const CustomIcon.dollarIcon({super.key})
      : super(IconDataConstants.dollar,
            color: DefaultColorPalette.vanillaGreen);

  const CustomIcon.filterIcon({super.key}) : super(IconDataConstants.filter);

  const CustomIcon.person({super.key}) : super(IconDataConstants.person);

  const CustomIcon.drawer({super.key})
      : super(IconDataConstants.menu, color: DefaultColorPalette.vanillaBlack);

  CustomIcon.exit({super.key})
      : super(IconDataConstants.exit, color: DefaultColorPalette.grey500);

  CustomIcon.searchIcon({super.key})
      : super(IconDataConstants.search, color: DefaultColorPalette.grey600);
}

final class IconDataConstants {
  static const IconData dollar = Icons.attach_money_rounded;
  static const IconData euro = Icons.euro_rounded;
  static const IconData back = Icons.arrow_back_ios_new_rounded;
  static const IconData calendar = Icons.calendar_today;
  static const IconData filter = Icons.filter_alt_rounded;
  static const IconData send = Icons.send;
  static const IconData wallet = Icons.wallet;
  static const IconData download = Icons.download;
  static const IconData person = Icons.person_rounded;
  static const IconData exit = Icons.exit_to_app_rounded;
  static const IconData search = Icons.search;
  static const IconData menu = Icons.menu;
}

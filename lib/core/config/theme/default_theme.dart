import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData defaultTheme = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: DefaultColorPalette.vanillaWhite,
  colorScheme: defaultColorScheme,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: DefaultColorPalette.primaryDarkBlue,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: defaultColorScheme.primary,
  ),
);

///Default Color Scheme for ThemeData
final ColorScheme defaultColorScheme = ColorScheme.light(
  brightness: Brightness.light,
  primary: DefaultColorPalette.mainBlue,
  onPrimary: DefaultColorPalette.primaryDarkBlue,
  secondary: DefaultColorPalette.mainBlue,
  onSecondary: DefaultColorPalette.vanillaBlack,
  error: DefaultColorPalette.errorRed,
  onError: DefaultColorPalette.vanillaWhite,
  surface: DefaultColorPalette.vanillaWhite,
  onSurface: DefaultColorPalette.vanillaBlack,
);

///Color Palettte for Default Theme
final class DefaultColorPalette {
  ///gold color
  static const Color primaryGold = Color.fromARGB(255, 230, 178, 58);

  ///dark blue
  static const Color primaryDarkBlue = Color.fromARGB(161, 5, 34, 48);

  ///dark red
  static const Color errorRed = Color.fromARGB(130, 244, 67, 54);

  static Color randomColor() => Color.fromARGB(
      255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  static Color opacityPurple = Colors.purple.shade200.withValues(alpha: 1);
  static Color opacityRed = Colors.red.withValues(alpha: 0.2);
  static Color opacityBlack = Colors.black.withValues(alpha: 0.2);
  static Color opacityWhite = Colors.white.withValues(alpha: 0.9);

  static Color grey100 = Colors.grey.shade100;
  static Color grey300 = Colors.grey.shade300;
  static Color grey400 = Colors.grey.shade400;
  static Color grey500 = Colors.grey.shade500;
  static Color grey600 = Colors.grey.shade600;
  static Color grey700 = Colors.grey.shade700;

  static Color mainBlue = const Color.fromRGBO(25, 127, 229, 1);
  static Color mainWhite = const Color.fromRGBO(239, 242, 244, 1);
  static Color mainTextBlack = const Color.fromRGBO(17, 20, 22, 1);

  static Color customGrey = const Color.fromRGBO(99, 117, 135, 1);
  static Color customGreyLight = const Color.fromRGBO(219, 224, 229, 1);
  static Color customGreyLightX = const Color.fromRGBO(239, 242, 244, 1);


  static Color purple500 = Colors.purple.shade500;

  ///default white color in material 3
  static const Color vanillaWhite = Colors.white;
  static const Color vanillaBlack = Colors.black;
  static const Color vanillaGreen = Colors.green;
  static const Color vanillaTranparent = Colors.transparent;
}

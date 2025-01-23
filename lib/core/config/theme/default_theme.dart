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
const ColorScheme defaultColorScheme = ColorScheme.light(
  brightness: Brightness.light,
  primary: DefaultColorPalette.primaryGold,
  onPrimary: DefaultColorPalette.primaryDarkBlue,
  secondary: DefaultColorPalette.primaryGold,
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

  static Color grey100 = Colors.grey.shade100;
  static Color grey400 = Colors.grey.shade400;
  static Color grey500 = Colors.grey.shade500;

  ///default white color in material 3
  static const Color vanillaWhite = Colors.white;
  static const Color vanillaBlack = Colors.black;
  static const Color vanillaGreen = Colors.green;
  static const Color vanillaTranparent = Colors.transparent;
}

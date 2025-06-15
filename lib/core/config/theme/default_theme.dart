import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Light Theme
final ThemeData defaultTheme = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.manropeTextTheme(),
  scaffoldBackgroundColor: DefaultColorPalette.grey100,
  colorScheme: defaultColorScheme,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: DefaultColorPalette.grey100,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: defaultColorScheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: DefaultColorPalette.mainBlue,
      foregroundColor: DefaultColorPalette.vanillaWhite,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: DefaultColorPalette.mainBlue,
      foregroundColor: DefaultColorPalette.vanillaWhite,
    ),
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.manropeTextTheme(
    ThemeData.dark().textTheme,
  ),
  scaffoldBackgroundColor: DarkColorPalette.darkBackground,
  colorScheme: darkColorScheme,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: DarkColorPalette.darkBackground,
    foregroundColor: DarkColorPalette.darkOnSurface,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: darkColorScheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: DarkColorPalette.darkPrimary,
      foregroundColor: DarkColorPalette.darkOnPrimary,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: DarkColorPalette.darkPrimary,
      foregroundColor: DarkColorPalette.darkOnPrimary,
    ),
  ),
  cardTheme: const CardThemeData(
    color: DarkColorPalette.darkSurface,
    elevation: 2,
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: DarkColorPalette.darkSurface,
  ),
);

///Default Color Scheme for Light Theme
final ColorScheme defaultColorScheme = ColorScheme.light(
  brightness: Brightness.light,
  primary: DefaultColorPalette.mainBlue,
  onPrimary: DefaultColorPalette.vanillaWhite,
  secondary: DefaultColorPalette.mainBlue,
  onSecondary: DefaultColorPalette.vanillaBlack,
  error: DefaultColorPalette.errorRed,
  onError: DefaultColorPalette.vanillaWhite,
  surface: DefaultColorPalette.vanillaWhite,
  onSurface: DefaultColorPalette.vanillaBlack,
  background: DefaultColorPalette.grey100,
  onBackground: DefaultColorPalette.vanillaBlack,
);

///Dark Color Scheme
final ColorScheme darkColorScheme = ColorScheme.dark(
  brightness: Brightness.dark,
  primary: DarkColorPalette.darkPrimary,
  onPrimary: DarkColorPalette.darkOnPrimary,
  secondary: DarkColorPalette.darkSecondary,
  onSecondary: DarkColorPalette.darkOnSecondary,
  error: DarkColorPalette.darkError,
  onError: DarkColorPalette.darkOnError,
  surface: DarkColorPalette.darkSurface,
  onSurface: DarkColorPalette.darkOnSurface,
  background: DarkColorPalette.darkBackground,
  onBackground: DarkColorPalette.darkOnBackground,
);

///Color Palette for Default (Light) Theme
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

///Color Palette for Dark Theme
final class DarkColorPalette {
  // Modern dark theme colors
  static const Color darkBackground =
      Color(0xFF121212); // Material Design dark background
  static const Color darkSurface = Color(0xFF1E1E1E); // Elevated surface
  static const Color darkSurfaceVariant = Color(0xFF2D2D2D); // Card backgrounds

  // Primary colors (keeping your blue theme)
  static const Color darkPrimary =
      Color.fromRGBO(25, 127, 229, 1); // Your main blue
  static const Color darkOnPrimary = Color(0xFFFFFFFF);

  // Secondary colors
  static const Color darkSecondary = Color(0xFF64B5F6); // Lighter blue
  static const Color darkOnSecondary = Color(0xFF000000);

  // Text colors
  static const Color darkOnSurface = Color(0xFFE1E1E1); // Primary text
  static const Color darkOnBackground = Color(0xFFE1E1E1);
  static const Color darkOnSurfaceVariant = Color(0xFFB3B3B3); // Secondary text

  // Error colors
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkOnError = Color(0xFF000000);

  // Additional utility colors
  static const Color darkOutline = Color(0xFF3D3D3D);
  static const Color darkOutlineVariant = Color(0xFF2D2D2D);

  // Opacity colors for dark theme
  static Color darkOpacityWhite = Colors.white.withValues(alpha: 0.1);
  static Color darkOpacityBlack = Colors.black.withValues(alpha: 0.4);

  // Grey shades for dark theme
  static const Color darkGrey100 = Color(0xFF2D2D2D);
  static const Color darkGrey200 = Color(0xFF3A3A3A);
  static const Color darkGrey300 = Color(0xFF4A4A4A);
  static const Color darkGrey400 = Color(0xFF5A5A5A);
  static const Color darkGrey500 = Color(0xFF6A6A6A);
}

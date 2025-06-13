import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Light tema
ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: DefaultColorPalette.vanillaWhite,
      colorScheme: lightColorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: DefaultColorPalette.primaryDarkBlue,
        foregroundColor: DefaultColorPalette.vanillaWhite,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightColorScheme.primary,
        contentTextStyle: TextStyle(color: lightColorScheme.onPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: DefaultColorPalette.vanillaWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

// Dark tema
ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: DarkColorPalette.vanillaWhite,
        displayColor: DarkColorPalette.vanillaWhite,
      ),
      scaffoldBackgroundColor: DarkColorPalette.darkBackground,
      colorScheme: darkColorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: DarkColorPalette.darkSurface,
        foregroundColor: DarkColorPalette.vanillaWhite,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkColorScheme.primary,
        contentTextStyle: TextStyle(color: darkColorScheme.onPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: DarkColorPalette.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

// Light tema color scheme
final ColorScheme lightColorScheme = ColorScheme.light(
  brightness: Brightness.light,
  primary: DefaultColorPalette.mainBlue,
  onPrimary: DefaultColorPalette.vanillaWhite,
  secondary: DefaultColorPalette.primaryGold,
  onSecondary: DefaultColorPalette.vanillaBlack,
  error: DefaultColorPalette.errorRed,
  onError: DefaultColorPalette.vanillaWhite,
  surface: DefaultColorPalette.vanillaWhite,
  onSurface: DefaultColorPalette.vanillaBlack,
  background: DefaultColorPalette.mainWhite,
  onBackground: DefaultColorPalette.mainTextBlack,
);

// Dark tema color scheme
final ColorScheme darkColorScheme = ColorScheme.dark(
  brightness: Brightness.dark,
  primary: DarkColorPalette.primaryBlue,
  onPrimary: DarkColorPalette.vanillaWhite,
  secondary: DarkColorPalette.secondaryGold,
  onSecondary: DarkColorPalette.vanillaBlack,
  error: DarkColorPalette.errorRed,
  onError: DarkColorPalette.vanillaWhite,
  surface: DarkColorPalette.darkSurface,
  onSurface: DarkColorPalette.vanillaWhite,
  background: DarkColorPalette.darkBackground,
  onBackground: DarkColorPalette.vanillaWhite,
);

// Mevcut Default Color Palette (Light tema için)
final class DefaultColorPalette {
  static const Color primaryGold = Color.fromARGB(255, 230, 178, 58);
  static const Color primaryDarkBlue = Color.fromARGB(161, 5, 34, 48);
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

  static const Color vanillaWhite = Colors.white;
  static const Color vanillaBlack = Colors.black;
  static const Color vanillaGreen = Colors.green;
  static const Color vanillaTranparent = Colors.transparent;
}

// Dark tema için color palette
final class DarkColorPalette {
  static const Color primaryBlue = Color.fromRGBO(66, 165, 245, 1);
  static const Color secondaryGold = Color.fromARGB(255, 255, 193, 7);
  static const Color errorRed = Color.fromARGB(255, 244, 67, 54);

  static const Color darkBackground = Color.fromRGBO(18, 18, 18, 1);
  static const Color darkSurface = Color.fromRGBO(33, 33, 33, 1);
  static const Color darkSurfaceVariant = Color.fromRGBO(48, 48, 48, 1);

  static Color grey800 = Colors.grey.shade800;
  static Color grey700 = Colors.grey.shade700;
  static Color grey600 = Colors.grey.shade600;
  static Color grey500 = Colors.grey.shade500;
  static Color grey400 = Colors.grey.shade400;
  static Color grey300 = Colors.grey.shade300;

  static const Color vanillaWhite = Colors.white;
  static const Color vanillaBlack = Colors.black;
  static const Color vanillaTranparent = Colors.transparent;
}

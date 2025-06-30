// ignore_for_file: unused_element

import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

///class set the style of Text Widgets.
final class CustomTextStyle {
  //gpt nin gücü adına :)

  static TextStyle _baseStyle({required Color color, required double size}) {
    return TextStyle(color: color, fontSize: size);
  }

  static TextStyle _basePoppinStyle(
      {required Color color, required double size}) {
    return GoogleFonts.poppins(color: color, fontSize: size);
  }

  // Tema duyarlı renk getiren yardımcı method
  static Color _getThemeAwareColor(
      BuildContext context, Color lightColor, Color darkColor) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkColor
        : lightColor;
  }

  static TextStyle balanceTextStyle(BuildContext context, bool isLight) =>
      _baseStyle(
      color: isLight
              ? _getThemeAwareColor(context, DefaultColorPalette.grey400,
                  DefaultColorPalette.vanillaWhite)
              : _getThemeAwareColor(context, DefaultColorPalette.vanillaBlack,
                  DefaultColorPalette.vanillaWhite),
      size: 32);

  static TextStyle goldColorPoppins(double size) =>
      _basePoppinStyle(color: defaultTheme.primaryColor, size: size);

  static TextStyle whiteColorPoppins(double size) =>
      _basePoppinStyle(color: DefaultColorPalette.vanillaWhite, size: size);

  static TextStyle blackColorPoppins(BuildContext context, double size) =>
      _basePoppinStyle(
          color: _getThemeAwareColor(context, DefaultColorPalette.vanillaBlack,
              DefaultColorPalette.vanillaWhite),
          size: size);

  static TextStyle greyColorPoppins(BuildContext context, double size) =>
      _basePoppinStyle(
          color: _getThemeAwareColor(context, DefaultColorPalette.customGrey,
              DefaultColorPalette.grey400),
          size: size);

  static TextStyle greyColorManrope(BuildContext context, double size) =>
      TextStyle(
        color: _getThemeAwareColor(context, DefaultColorPalette.customGrey,
            DefaultColorPalette.grey400),
        fontFamily: 'Manrope',
        fontSize: size,
      );

  static TextStyle loginButtonTextStyle(
          BuildContext context, Color? customColor) =>
      TextStyle(
        color: customColor ??
            _getThemeAwareColor(context, DefaultColorPalette.vanillaBlack,
                DefaultColorPalette.vanillaWhite),
        fontFamily: 'Manrope',
        fontSize: AppSize.mediumText,
        letterSpacing: 0,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  static TextStyle blackColorBoldPoppins(BuildContext context, double size) =>
      GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: _getThemeAwareColor(context, DefaultColorPalette.vanillaBlack,
            DefaultColorPalette.vanillaWhite),
        fontSize: size,
      );

  static TextStyle profitColorPoppins(double size, double? position) =>
      GoogleFonts.poppins(
        color: position == 1
            ? DefaultColorPalette.vanillaGreen
            : DefaultColorPalette.errorRed,
        fontSize: size,
      );

  static TextStyle redColorPoppins(double size) =>
      _basePoppinStyle(color: DefaultColorPalette.errorRed, size: size);

  static TextStyle greenColorPoppins(double size) =>
      _basePoppinStyle(color: DefaultColorPalette.vanillaGreen, size: size);

  // Tema duyarlı genel text style'ları
  static TextStyle primaryTextStyle(BuildContext context, double size) =>
      _basePoppinStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color ??
              _getThemeAwareColor(context, DefaultColorPalette.vanillaBlack,
                  DefaultColorPalette.vanillaWhite),
          size: size);

  static TextStyle secondaryTextStyle(BuildContext context, double size) =>
      _basePoppinStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color ??
              _getThemeAwareColor(context, DefaultColorPalette.customGrey,
                  DefaultColorPalette.grey400),
          size: size);
}

/// Helper class for box decoration style in Containers.
final class CustomDecoration extends BoxDecoration {
  CustomDecoration.roundBox(
      {required double radius,
      Color? borderColor,
      Color? containerColor,
      double? borderWidth})
      : super(
          border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? AppSize.defaultBorderWidth),
          borderRadius: BorderRadius.circular(radius),
          color: containerColor ?? DefaultColorPalette.vanillaTranparent,
        );

  // Tema duyarlı box decoration
  CustomDecoration.roundBoxThemeAware(BuildContext context,
      {required double radius,
      Color? lightBorderColor,
      Color? darkBorderColor,
      Color? lightContainerColor,
      Color? darkContainerColor,
      double? borderWidth})
      : super(
          border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? (darkBorderColor ?? Colors.grey.shade700)
                  : (lightBorderColor ?? Colors.transparent),
              width: borderWidth ?? AppSize.defaultBorderWidth),
          borderRadius: BorderRadius.circular(radius),
          color: Theme.of(context).brightness == Brightness.dark
              ? (darkContainerColor ?? Colors.grey.shade800)
              : (lightContainerColor ?? DefaultColorPalette.vanillaTranparent),
        );
}

///Helper Class for custom text form fields.
final class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration.customRoundInput(
      {required String? label, required double radius})
      : super(
          label: Text(label ?? DefaultLocalStrings.emptyText),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        );

  CustomInputDecoration.mediumRoundInput(
      {
    required String? label,
    IconData? icon,
    Color? fillColor,
    bool hasLabel = true,
  })
      : super(
          fillColor: fillColor ?? DefaultColorPalette.customGreyLightX,
          filled: true,
          label: hasLabel ? Text(label ?? DefaultLocalStrings.emptyText) : null,
          icon: icon != null ? Icon(icon) : null,
          labelStyle: TextStyle(
            color: DefaultColorPalette.customGrey,
            fontFamily: 'Manrope',
            fontSize: AppSize.smallText2,
          ),
          enabledBorder: defaultInputBorder(),
          focusedBorder: focusedInputBorder(),
          errorBorder: errorInputBorder(),
          focusedErrorBorder: errorInputBorder(),
          hintText: label,
          hintStyle: TextStyle(
            color: DefaultColorPalette.customGrey,
            fontFamily: 'Manrope',
            fontSize: AppSize.smallText2,
            fontWeight: FontWeight.normal,
          ),
        );

  CustomInputDecoration.buildThemeAwareDecoration({
    required String label,
    required bool hasLabel,
    required ThemeData theme,
    required bool isDarkMode,
    required Color backgroundColor,
    required Color borderColor,
    required Color hintColor,
  }) : super() {
    InputDecoration(
      labelText: hasLabel ? label : null,
      hintText: !hasLabel ? label : null,
      filled: true,
      fillColor: backgroundColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      labelStyle: TextStyle(
        color: hintColor,
        fontFamily: 'Manrope',
      ),
      hintStyle: TextStyle(
        color: hintColor,
        fontFamily: 'Manrope',
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: borderColor,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.primaryColor,
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
          width: 2.0,
        ),
      ),
      errorStyle: TextStyle(
        color: theme.colorScheme.error,
        fontFamily: 'Manrope',
      ),
    );
  }

  // Tema duyarlı input decoration
  CustomInputDecoration.mediumRoundInputThemeAware(
    BuildContext context, {
    required String? label,
    IconData? icon,
    Color? fillColor,
    bool hasLabel = true,
  }) : super(
          fillColor: fillColor ??
              (Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : DefaultColorPalette.customGreyLightX),
          filled: true,
          label: hasLabel ? Text(label ?? DefaultLocalStrings.emptyText) : null,
          icon: icon != null ? Icon(icon) : null,
          labelStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade400
                : DefaultColorPalette.customGrey,
            fontFamily: 'Manrope',
            fontSize: AppSize.smallText2,
          ),
          enabledBorder: defaultInputBorderThemeAware(context),
          focusedBorder: focusedInputBorderThemeAware(context),
          errorBorder: errorInputBorder(),
          focusedErrorBorder: errorInputBorder(),
          hintText: label,
          hintStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade400
                : DefaultColorPalette.customGrey,
            fontFamily: 'Manrope',
            fontSize: AppSize.smallText2,
            fontWeight: FontWeight.normal,
          ),
        );

  static OutlineInputBorder defaultInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: DefaultColorPalette.customGreyLight,
        width: AppSize.defaultBorderWidth,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(AppSize.mediumRadius),
    );
  }

  static OutlineInputBorder defaultInputBorderThemeAware(BuildContext context) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade600
            : DefaultColorPalette.customGreyLight,
        width: AppSize.defaultBorderWidth,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(AppSize.mediumRadius),
    );
  }

  static OutlineInputBorder focusedInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.mediumRadius),
      borderSide: BorderSide(
        color: DefaultColorPalette.mainBlue,
        width: 2.r,
      ),
    );
  }

  static OutlineInputBorder focusedInputBorderThemeAware(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.mediumRadius),
      borderSide: BorderSide(
        color: DefaultColorPalette.mainBlue,
        width: 2.r,
      ),
    );
  }

  static OutlineInputBorder errorInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.mediumRadius),
      borderSide: BorderSide(
        color: DefaultColorPalette.errorRed,
        width: 2.r,
      ),
    );
  }
}

// ignore_for_file: unused_element

import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:flutter/material.dart';
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

  static TextStyle balanceTextStyle(bool isLight) => _baseStyle(
      color: isLight
          ? DefaultColorPalette.grey400
          : DefaultColorPalette.vanillaBlack,
      size: 32);

  static TextStyle goldColorPoppins(double size) =>
      _basePoppinStyle(color: defaultTheme.primaryColor, size: size);

  static TextStyle whiteColorPoppins(double size) =>
      _basePoppinStyle(color: DefaultColorPalette.vanillaWhite, size: size);

  static TextStyle blackColorPoppins(double size) =>
      _basePoppinStyle(color: DefaultColorPalette.vanillaBlack, size: size);
  
  static TextStyle blackColorBoldPoppins(double size) => GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: DefaultColorPalette.vanillaBlack,
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
}
///Helper Class for custom text form fields.

final class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration.customRoundInput(
      {required String? label, required double radius})
      : super(
            label: Text(label ?? DefaultLocalStrings.emptyText),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius)));

  CustomInputDecoration.mediumRoundInput(
      {required String? label, IconData? icon})
      : super(
            label: Text(label ?? DefaultLocalStrings.emptyText),
            icon: icon != null ? Icon(icon) : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.mediumRadius)));

  //this methods fills the border design

}

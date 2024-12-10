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

  static TextStyle goldColorPoppins(double size) =>
      _basePoppinStyle(color: defaultTheme.primaryColor, size: size);

  static TextStyle whiteColorPoppins(double size) =>
      _basePoppinStyle(color: DefaultColorPalette.vanillaWhite, size: size);

  static TextStyle blackColorPoppins(double size) =>
      _basePoppinStyle(color: DefaultColorPalette.vanillaBlack, size: size);
}

final class CustomDecoration {
  static roundBox(
    Color? borderColor,
    double? borderWidth,
    Color? containerColor, {
    required double radius,
  }) {
    return BoxDecoration(
      color: containerColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
          color: borderColor ?? DefaultColorPalette.vanillaTranparent,
          width: borderWidth ?? AppSize.defaultBorderWidth),
    );
  }
}

final class CustomInputDecoration {
  //base input decoration sets the label text and waits a border
  static _baseInputDecoration(
      {required String? label, required InputBorder border}) {
    return InputDecoration(
      label: Text(label ?? DefaultLocalStrings.emptyText),
      border: border,
    );
  }

  //this methods fills the border design

  static outlineRoundInput(String? label, {required double radius}) {
    return _baseInputDecoration(
        label: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ));
  }
}

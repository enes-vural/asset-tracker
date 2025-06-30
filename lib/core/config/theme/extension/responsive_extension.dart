import 'package:flutter/material.dart';
///extension which help you to get percent for ResponsiveSize class
///* toSmall => %10
///* toMedium => %25
///* toLarge => %30
///* toHuge => %40
///* toHalf => %50
extension SizeConvert on double {
  // Small size percent 10
  double toSmall() => this * 0.1;

  // Medium size percent 25
  double toMedium() => this * 0.25;

  // Large size percent 30
  double toLarge() => this * 0.30;

  // Huge size percent 40
  double toHuge() => this * 0.40;

  double toHalf() => this * 0.50;

  /// Custom size for dynamic circumstances
  double toPercent(double percent) => this * (percent / 100);
}

///Gets device screen size with MediaQuery
extension ResponsiveSize on BuildContext {
  // Screen size properties
  Size get screenSize => MediaQuery.of(this).size;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}

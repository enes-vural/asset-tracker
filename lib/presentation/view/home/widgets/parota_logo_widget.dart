import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaRotaLogoWidget extends StatelessWidget {
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? pColor;
  final Color? rColor;
  final Color? otherLettersColor;

  const PaRotaLogoWidget({
    super.key,
    this.fontSize,
    this.fontWeight,
    this.pColor,
    this.rColor,
    this.otherLettersColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultOtherLettersColor = isDark
        ? const Color(0xFF9CA3AF) // açık gri (dark mode için)
        : const Color(0xFF374151); // koyu gri (light mode için)

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize ?? 24.sp,
          fontFamily: "Manrope",
          fontWeight: fontWeight ?? FontWeight.w700,
          height: 1.0,
        ),
        children: [
          TextSpan(
            text: 'P',
            style: TextStyle(
              color: pColor ?? const Color(0xFF2563EB),
            ),
          ),
          TextSpan(
            text: 'a',
            style: TextStyle(
              color: otherLettersColor ?? defaultOtherLettersColor,
            ),
          ),
          TextSpan(
            text: 'R',
            style: TextStyle(
              color: rColor ?? const Color(0xFF1E40AF),
            ),
          ),
          TextSpan(
            text: 'ota',
            style: TextStyle(
              color: otherLettersColor ?? defaultOtherLettersColor,
            ),
          ),
        ],
      ),
    );
  }
}

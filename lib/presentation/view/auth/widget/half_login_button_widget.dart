import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HalfLoginButton extends StatelessWidget {
  const HalfLoginButton({
    super.key,
    required this.label,
    required this.textStyle,
    required this.onPressed,
    required this.color,
  });

  final String label;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 48.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.mediumRadius),
            ),
            color: color,
          ),
          child: SizedBox(
            height: AppSize.mediumText.h,
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

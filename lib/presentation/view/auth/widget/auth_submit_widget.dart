import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/widgets/custom_align.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthSubmitWidget extends StatelessWidget {
  const AuthSubmitWidget({
    super.key,
    required this.label,
    required this.voidCallBack,
  });

  final String label;
  final VoidCallback voidCallBack;

  @override
  Widget build(BuildContext context) {
    return CustomAlign.center(
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: voidCallBack,
          style: ElevatedButton.styleFrom(
            backgroundColor: DefaultColorPalette.mainBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.largeRadius),
            ),
            elevation: 0,
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Manrope',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/theme/style_theme.dart';

class AuthSubmitWidget extends StatelessWidget {
  const AuthSubmitWidget({
    super.key,
    required this.label,
    required this.voidCallBack,
  });

  final String label;
  final VoidCallback? voidCallBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => voidCallBack,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          // percent %8 height
          height: ResponsiveSize(context).screenHeight.toCustom(8),
          //percent %50 width
          width: ResponsiveSize(context).screenWidth.toHalf(),
          //burası değişecek
          decoration: CustomDecoration.roundBox(
            //container and border color can be null,
            //it changes by container type so we set nullable type variable in here
            borderColor: Theme.of(context).primaryColor,
            borderWidth: AppSize.smallBorderWidth,
            containerColor: null,
            radius: AppSize.mediumRadius,
          ),
          child: Center(
            child: Text(
              label,
              style: CustomTextStyle.goldColorPoppins(AppSize.mediumText),
            ),
          ),
        ),
      ),
    );
  }
}

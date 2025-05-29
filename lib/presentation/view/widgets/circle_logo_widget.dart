import 'package:asset_tracker/core/constants/asset_constant.dart';
import 'package:asset_tracker/core/config/theme/extension/asset_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleMainLogoWidget extends StatelessWidget {
  const CircleMainLogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetConstant.mainLogo.toPng(),
      width: 250.w,
    );
  }
}

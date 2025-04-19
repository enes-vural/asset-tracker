import 'package:asset_tracker/core/constants/asset_constant.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/asset_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:flutter/material.dart';

class CircleMainLogoWidget extends StatelessWidget {
  const CircleMainLogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: DefaultColorPalette.vanillaTranparent,
      radius: ResponsiveSize(context).screenHeight.toSmall(),
      child: Image.asset(AssetConstant.mainLogo.toPng()),
    );
  }
}

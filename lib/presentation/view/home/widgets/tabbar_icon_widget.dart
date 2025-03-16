import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabBarIconWidget extends ConsumerWidget {
  const TabBarIconWidget({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const CustomSizedBox.mediumWidth(),
        InkWell(
          splashFactory: NoSplash.splashFactory,
          onTap: onTap,
          child: Container(
            height: 60,
            width: ResponsiveSize(context).screenWidth.toPercent(20),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(AppSize.largeRadius),
            ),
            child: Icon(
              icon,
              color: DefaultColorPalette.purple500,
              size: AppSize.largeIcon,
            ),
          ),
        ),
      ],
    );
  }
}

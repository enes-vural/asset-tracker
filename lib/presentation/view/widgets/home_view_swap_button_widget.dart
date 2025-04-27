import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
class HomeViewSwapButtonWidget extends StatelessWidget {
  const HomeViewSwapButtonWidget({
    super.key,
    required this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomPadding.mediumHorizontal(
        widget: Container(
          width: MediaQuery.of(context).size.width.toPercent(33) - 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.hugeRadius),
            color:
                DefaultColorPalette.opacityPurple,
            boxShadow: [
              BoxShadow(
                color: DefaultColorPalette.opacityRed,
                blurRadius: 10.0,
                offset: const Offset(0, 4), // Alt tarafa doğru gölge
              ),
            ],
          ),
          child: Center(
            child: SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  LocaleKeys.home_clear.tr(),
                  style: CustomTextStyle.whiteColorPoppins(AppSize.mediumText),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

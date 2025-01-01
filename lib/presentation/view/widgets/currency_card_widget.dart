import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/config/localization/generated/locale_keys.g.dart';
import '../../../core/config/theme/default_theme.dart';
import '../../../core/config/theme/extension/app_size_extension.dart';
import '../../../core/config/theme/style_theme.dart';
import '../../../core/widgets/custom_padding.dart';
import '../../../domain/entities/web/socket/currency_widget_entity.dart';

class CurrencyCardWidget extends StatelessWidget {
  const CurrencyCardWidget({
    super.key,
    required this.currency,
  });

  final CurrencyWidgetEntity currency;

  @override
  Widget build(BuildContext context) {
    return CustomPadding.mediumTop(
      widget: InkWell(
          child: Container(
        height: ResponsiveSize(context).screenHeight.toPercent(6.5),
        decoration: CustomDecoration.roundBox(
            radius: AppSize.mediumRadius,
            borderColor: DefaultColorPalette.vanillaBlack,
            containerColor: DefaultColorPalette.vanillaTranparent,
            borderWidth: AppSize.defaultBorderWidth),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "\t${currency.name}",
              textAlign: TextAlign.start,
              style: CustomTextStyle.blackColorPoppins(AppSize.mediumText),
            ),
            Text(
              "${LocaleKeys.home_buy.tr()}: ${currency.alis}",
              textAlign: TextAlign.center,
              style: CustomTextStyle.redColorPoppins(AppSize.smallText2),
            ),
            Text(
              "${LocaleKeys.home_sell.tr()}: ${currency.satis}",
              textAlign: TextAlign.end,
              style: CustomTextStyle.greenColorPoppins(AppSize.smallText2),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      )),
    );
  }
}

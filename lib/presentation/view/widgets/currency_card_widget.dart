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
        height: ResponsiveSize(context).screenHeight.toPercent(8),
        decoration: CustomDecoration.roundBox(
          radius: AppSize.mediumRadius,
          borderColor: DefaultColorPalette.vanillaWhite,
          containerColor: DefaultColorPalette.vanillaWhite,
          borderWidth: AppSize.defaultBorderWidth,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomPadding.smallHorizontal(
                    widget: CircleAvatar(
                      radius: 22.0,
                      child: Image.asset(
                        currency.getCurrencyIcon(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currency.name.toString(),
                        style: CustomTextStyle.blackColorBoldPoppins(14.0),
                        overflow: TextOverflow.clip,
                      ),
                      Text(
                        currency.code.toString(),
                        style: CustomTextStyle.blackColorPoppins(12.0),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Satış Fiyatı",
                    style: CustomTextStyle.blackColorPoppins(12.0),
                  ),
                  Text(
                    currency.satis.toString(),
                    style: CustomTextStyle.blackColorBoldPoppins(14.0),
                  ),
                ],
              )),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: setIcon(currency.dir.satisDir),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Icon setIcon(dynamic parameter) {
    return parameter == CurrencyDirectionEnum.UP.value
        ? const Icon(Icons.arrow_upward,
            color: DefaultColorPalette.vanillaGreen)
        : parameter == CurrencyDirectionEnum.DOWN.value
            ? const Icon(Icons.arrow_downward,
                color: DefaultColorPalette.errorRed)
            : Icon(
                Icons.exposure_zero_outlined,
                color: DefaultColorPalette.grey400,
              );
  }

}


//test@gmail.com
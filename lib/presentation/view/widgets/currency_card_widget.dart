import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/config/localization/generated/locale_keys.g.dart';
import '../../../core/config/theme/default_theme.dart';
import '../../../core/config/theme/extension/app_size_extension.dart';
import '../../../core/config/theme/style_theme.dart';
import '../../../core/widgets/custom_padding.dart';
import '../../../domain/entities/web/socket/currency_widget_entity.dart';
import '../../../core/mixins/get_currency_icon_mixin.dart';

class CurrencyCardWidget extends StatelessWidget with GetCurrencyIconMixin {
  const CurrencyCardWidget({
    super.key,
    required this.currency,
    required this.onTap,
  });

  final CurrencyWidgetEntity currency;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomPadding.mediumTop(
      widget: InkWell(
          onTap: onTap,
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
            _currencyInfoWidget(),
            _currencyPriceWidget(),
            _currencyDirectionWidget(),
          ],
        ),
      )),
    );
  }

  Expanded _currencyDirectionWidget() {
    return Expanded(
      flex: 2,
      child: Center(
        child: _setIcon(currency.dir.satisDir),
      ),
    );
  }

  Expanded _currencyPriceWidget() {
    return Expanded(
      flex: 3,
      child: SizedBox(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.home_sell.tr(),
            style: CustomTextStyle.blackColorPoppins(AppSize.smallText),
          ),
          Text(
            currency.satis.toString(),
            style: CustomTextStyle.blackColorBoldPoppins(AppSize.small2Text),
          ),
        ],
      )),
    );
  }

  Expanded _currencyInfoWidget() {
    return Expanded(
      flex: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomPadding.smallHorizontal(
            widget: CircleAvatar(
              radius: AppSize.hugeRadius,
              child: Image.asset(
                getCurrencyIcon(currency.name),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const CustomSizedBox.smallGap(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currency.name.toString(),
                style:
                    CustomTextStyle.blackColorBoldPoppins(AppSize.smallText2),
                overflow: TextOverflow.clip,
              ),
              Text(
                currency.code.toString(),
                style: CustomTextStyle.blackColorPoppins(AppSize.smallText),
                overflow: TextOverflow.clip,
              )
            ],
          )
        ],
      ),
    );
  }

  Icon _setIcon(String directionValue) {
    if (directionValue == CurrencyDirectionEnum.UP.value) {
      return const Icon(Icons.arrow_upward,
          color: DefaultColorPalette.vanillaGreen);
    } else if (directionValue == CurrencyDirectionEnum.DOWN.value) {
      return const Icon(Icons.arrow_downward,
          color: DefaultColorPalette.errorRed);
    } else {
      return Icon(Icons.exposure_zero_outlined,
          color: DefaultColorPalette.grey400);
    }
  }
}

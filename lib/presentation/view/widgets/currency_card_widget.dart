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
            _currencyCardTextWidget(
              _currencyTextLabel,
              CustomTextStyle.blackColorPoppins(AppSize.mediumText),
            ),
            _currencyCardTextWidget(_buyTextLabel,
                CustomTextStyle.redColorPoppins(AppSize.smallText2)),
            _currencyCardTextWidget(_sellTextLabel,
                CustomTextStyle.greenColorPoppins(AppSize.smallText2))
          ],
        ),
      )),
    );
  }

  ///"USD" 
  String get _currencyTextLabel => "\t${currency.name}";

  ///"ALIŞ : 8.0000"
  String get _buyTextLabel => "${LocaleKeys.home_buy.tr()}: ${currency.alis}";

  ///"SATIŞ : 8.0000"
  String get _sellTextLabel =>
      "${LocaleKeys.home_sell.tr()}: ${currency.satis}";

  ///Text widget for currency card
  Text _currencyCardTextWidget(
      String currencyLabel, TextStyle customTextStyle) {
    return Text(
      currencyLabel,
      textAlign: TextAlign.start,
      style: customTextStyle,
      overflow: TextOverflow.ellipsis,
    );
  }
}

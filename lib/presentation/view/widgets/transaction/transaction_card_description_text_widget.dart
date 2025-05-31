import 'package:asset_tracker/core/constants/enums/widgets/transaction_card_desc_text_type_enums.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/number_format_extension.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:flutter/material.dart';


class TransactionCardDescriptionTextWidget extends StatelessWidget {
  const TransactionCardDescriptionTextWidget({
    super.key,
    required this.label,
    required this.stats,
    required this.type,
  });

  final String? label;
  final double? stats;
  final TransactionCardDescriptionTextType type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label ?? DefaultLocalStrings.emptyBalance),
        Text("₺${stats?.toNumberWithTurkishFormat()}",
            style: type == TransactionCardDescriptionTextType.PROFIT
                ? CustomTextStyle.profitColorPoppins(
                    AppSize.largePadd, stats?.sign)
                : CustomTextStyle.blackColorPoppins(AppSize.largePadd)),
      ],
    );
  }
}

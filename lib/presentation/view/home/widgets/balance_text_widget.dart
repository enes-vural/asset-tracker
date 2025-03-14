import 'package:asset_tracker/core/config/constants/reg_exp_constant.dart';
import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalanceTextWidget extends ConsumerWidget {
  const BalanceTextWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currenctBalance =
        ref.watch(appGlobalProvider).getLatestBalance.toString();

    DefaultLocalStrings.emptyBalance;
    // Ondalık ayırma
    List<String> parts = currenctBalance.split(".");
    String wholePart = parts[0]; // Tam sayı kısmı

    String fractionPart =
        parts.length > 1 ? parts[1] : DefaultLocalStrings.emptyFraction;

    //remove fraction part if its length is greater than 2 mean its 3 or more
    fractionPart =
        fractionPart.length > 2 ? fractionPart.substring(0, 2) : fractionPart;

    //Divide whole part with 3 digits
    String formattedWholePart = wholePart.replaceAllMapped(
        RegExpConstant.divideBalance, (Match match) => '${match[1]}.');

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "₺$formattedWholePart",
            style: CustomTextStyle.balanceTextStyle(false),
          ),
          TextSpan(
            text: ",$fractionPart",
            style: CustomTextStyle.balanceTextStyle(true),
          ),
        ],
      ),
    );
  }
}

import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalanceProfitTextWidget extends ConsumerWidget {
  const BalanceProfitTextWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double? profitPercent =
        ref.watch(appGlobalProvider).getPercentProfit;

    bool isNegative() {
      if (profitPercent.toString().contains("-")) {
        return true;
      }
      return false;
    }

    return Row(
      children: [
        isNegative()
            ? const Icon(
                Icons.arrow_drop_down,
                color: DefaultColorPalette.errorRed,
              )
            : const Icon(
                Icons.arrow_drop_up,
                color: DefaultColorPalette.vanillaGreen,
              ),
        Text(
            "${ref.watch(appGlobalProvider.notifier).getUserData?.profit?.toStringAsFixed(2) ?? DefaultLocalStrings.emptyBalance}%"),
      ],
    );
  }
}

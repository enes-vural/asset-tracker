import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalanceProfitTextWidget extends ConsumerStatefulWidget {
  const BalanceProfitTextWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BalanceProfitTextWidgetState();
}

class _BalanceProfitTextWidgetState
    extends ConsumerState<BalanceProfitTextWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //authGlobal e direkt getter ile isAuthorized kontrolü eklenmesi lazım.
    //TODO:
    final currentUserId = ref.read(authGlobalProvider).getCurrentUser?.uid;

    if (currentUserId == null) {
      return const CustomSizedBox.empty();
    }

    double? profitPercent = ref.watch(appGlobalProvider).getPercentProfit;

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

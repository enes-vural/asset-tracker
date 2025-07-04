import 'package:asset_tracker/core/constants/reg_exp_constant.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class BalanceTextWidget extends ConsumerStatefulWidget {
  const BalanceTextWidget({super.key});

  @override
  ConsumerState<BalanceTextWidget> createState() => _BalanceTextWidgetState();
}

class _BalanceTextWidgetState extends ConsumerState<BalanceTextWidget> {
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
    final currentUserId = ref.read(authGlobalProvider).getCurrentUser?.uid;

    if (currentUserId == null) {
      return const CustomSizedBox.empty();
    }

    String toFormat(String number, bool isWholePart) {
      // Ondalık ayırma
      List<String> parts = number.split(".");
      String wholePart = parts[0]; // Tam sayı kısmı
      String fractionPart =
          parts.length > 1 ? parts[1] : DefaultLocalStrings.emptyFraction;

      //remove fraction part if its length is greater than 2 mean its 3 or more
      fractionPart =
          fractionPart.length > 2 ? fractionPart.substring(0, 2) : fractionPart;

      //Divide whole part with 3 digits
      String formattedWholePart = wholePart.replaceAllMapped(
          RegExpConstant.divideBalance, (Match match) => '${match[1]}.');

      if (isWholePart) {
        return formattedWholePart;
      } else {
        return fractionPart;
      }
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text:
                "₺${toFormat(ref.watch(appGlobalProvider).getLatestBalance.toString(), true)}",
            style: CustomTextStyle.balanceTextStyle(context, false),
          ),
          TextSpan(
            text:
                ",${toFormat(ref.watch(appGlobalProvider).getLatestBalance.toString(), false)}",
            style: CustomTextStyle.balanceTextStyle(context, true),
          ),
        ],
      ),
    );
  }
}

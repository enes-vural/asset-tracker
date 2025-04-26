import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/core/constants/global/general_constants.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/number_format_extension.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/presentation/view_model/home/dashboard/dashboard_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionCardLVBWidget extends ConsumerWidget {
  const TransactionCardLVBWidget({
    super.key,
    required this.entry,
    required this.viewModel,
  });

  final DashboardViewModel viewModel;
  final MapEntry<String, List<UserCurrencyEntity>> entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entry.value.length,
      itemBuilder: (context, index) {
        var transaction = entry.value[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.mediumRadius),
          ),
          elevation: 4,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction.currencyCode,
                  style: TextStyle(
                    color: DefaultColorPalette.grey700,
                    fontSize: AppSize.small2Text,
                  ),
                ),
                _transactionDateTextWidget(transaction),
              ],
            ),
            subtitle: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _transactionAmountTextWidget(transaction),
                    _transactionPerPriceTextWidget(transaction),
                    const CustomSizedBox.mediumGap(),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () async {
                        print("Remove button pressed");
                        await viewModel.removeTransaction(ref, transaction);

                        // Handle remove asset action
                        // Handle sell asset action
                      },
                      child: const Text(
                        "Remove",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const Expanded(child: CustomSizedBox.empty()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const CustomSizedBox.smallGap(),
                    _transactionPriceTextWidget(transaction),
                    const CustomSizedBox.mediumGap(),
                    transaction.transactionType == TransactionTypeEnum.BUY
                        ? TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () async {
                              print("Sell button pressed");
                              await viewModel.sellAsset(ref, transaction);
                            },
                            child: const Text(
                              "Sell",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 16),
                            ),
                          )
                        : const Text("Sold")
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Text _transactionPerPriceTextWidget(UserCurrencyEntity transaction) {
    return Text(
        "${LocaleKeys.dashboard_price.tr()}: ${transaction.price.toNumberWithTurkishFormat()}",
        style: const TextStyle(color: Colors.grey, fontSize: 14));
  }

  Text _transactionAmountTextWidget(UserCurrencyEntity transaction) {
    return Text(
      "${LocaleKeys.dashboard_amount.tr()}: ${transaction.amount}",
      style: const TextStyle(color: Colors.grey, fontSize: 14),
    );
  }

  Text _transactionDateTextWidget(UserCurrencyEntity transaction) {
    return Text(GeneralConstants.dateFormat.format(transaction.buyDate));
  }

  Text _transactionPriceTextWidget(UserCurrencyEntity transaction) {
    if (transaction.transactionType == TransactionTypeEnum.SELL) {
      return Text(
        DefaultLocalStrings.plus +
            DefaultLocalStrings.turkishLira +
            (transaction.price * transaction.amount)
                .toNumberWithTurkishFormat(),
        style: const TextStyle(
            color: DefaultColorPalette.vanillaGreen, fontSize: 16),
      );
    }
    return Text(
      DefaultLocalStrings.minus +
          DefaultLocalStrings.turkishLira +
          (transaction.price * transaction.amount).toNumberWithTurkishFormat(),
      style: const TextStyle(color: DefaultColorPalette.errorRed, fontSize: 16),
    );
  }
}

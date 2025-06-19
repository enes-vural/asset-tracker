import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/core/constants/global/general_constants.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/app_size.dart';
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
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Card(
            elevation: 3,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white,
                    transaction.transactionType == TransactionTypeEnum.BUY
                        ? Colors.blue.shade50.withOpacity(0.3)
                        : Colors.green.shade50.withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                  color: transaction.transactionType == TransactionTypeEnum.BUY
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left - Currency & Type
                    _buildCurrencySection(transaction),

                    const SizedBox(width: 16),

                    // Center - Transaction Details
                    Expanded(
                      child: _buildTransactionDetails(transaction),
                    ),

                    const SizedBox(width: 12),

                    // Right - Amount & Date
                    _buildAmountSection(transaction),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrencySection(UserCurrencyEntity transaction) {
    final isBuy = transaction.transactionType == TransactionTypeEnum.BUY;
    return Column(
      children: [
        const SizedBox(height: 6),
        Text(
          transaction.currencyCode.getCurrencyTitle(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          isBuy ? "ALIŞ" : "SATIŞ",
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: isBuy ? Colors.blue.shade600 : Colors.green.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionDetails(UserCurrencyEntity transaction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 14,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              "${transaction.amount}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
     
            const SizedBox(width: 6),
            Text(
              "₺${transaction.price.toNumberWithTurkishFormat()}",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountSection(UserCurrencyEntity transaction) {
    final totalAmount = transaction.price * transaction.amount;
    final isProfit = transaction.transactionType == TransactionTypeEnum.SELL;
    final color = isProfit
        ? DefaultColorPalette.vanillaGreen
        : DefaultColorPalette.errorRed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            "${isProfit ? '+' : '-'}₺${totalAmount.toNumberWithTurkishFormat()}",
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            GeneralConstants.dateFormat.format(transaction.buyDate),
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

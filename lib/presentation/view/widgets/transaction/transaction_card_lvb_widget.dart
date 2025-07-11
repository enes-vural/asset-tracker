import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/core/constants/global/general_constants.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/number_format_extension.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/presentation/view_model/home/dashboard/dashboard_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Tarihe göre sıralama - en yeni yukarıda, en eski aşağıda
    final sortedTransactions = List<UserCurrencyEntity>.from(entry.value)
      ..sort((a, b) => b.buyDate.compareTo(a.buyDate));
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedTransactions.length,
      itemBuilder: (context, index) {
        var transaction = sortedTransactions[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Card(
            elevation: isDark ? 8 : 3,
            shadowColor: (isDark ? Colors.black : Colors.black)
                .withOpacity(isDark ? 0.3 : 0.1),
            color: isDark ? Colors.grey[800] : Colors.white,
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
                    isDark ? Colors.grey[800]! : Colors.white,
                    transaction.transactionType == TransactionTypeEnum.BUY
                        ? (isDark
                            ? Colors.blue.shade900.withOpacity(0.4)
                            : Colors.blue.shade50.withOpacity(0.3))
                        : (isDark
                            ? Colors.green.shade900.withOpacity(0.4)
                            : Colors.green.shade50.withOpacity(0.3)),
                  ],
                ),
                border: Border.all(
                  color: transaction.transactionType == TransactionTypeEnum.BUY
                      ? Colors.blue.withOpacity(isDark ? 0.4 : 0.2)
                      : Colors.green.withOpacity(isDark ? 0.4 : 0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left - Currency & Type (Sabit genişlik)
                    SizedBox(
                      width: 60.w,
                      child: _buildCurrencySection(transaction, isDark),
                    ),

const CustomSizedBox.smallWidth(),

                    // Center - Transaction Details (Esnek genişlik)
                    Expanded(
                      flex: 2,
                      child: _buildTransactionDetails(transaction, isDark),
                    ),

                    const CustomSizedBox.smallWidth(),

                    // Right - Amount & Date (Sabit genişlik)
                    Expanded(
                      //width: 85.w,
                      flex: 3,
                      child: _buildAmountSection(transaction, isDark),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrencySection(UserCurrencyEntity transaction, bool isDark) {
    final isBuy = transaction.transactionType == TransactionTypeEnum.BUY;
    return Column(
      children: [
        const SizedBox(height: 6),
        Text(
          transaction.currencyCode.getCurrencyTitle().tr(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          isBuy ? "ALIŞ" : "SATIŞ",
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: isBuy
                ? (isDark ? Colors.blue.shade300 : Colors.blue.shade600)
                : (isDark ? Colors.green.shade300 : Colors.green.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionDetails(UserCurrencyEntity transaction, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Amount row - overflow koruması
        Row(
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                "${transaction.amount}",
                style: TextStyle(
                  fontSize: AppSize.smallText,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                "₺${transaction.price.toNumberWithTurkishFormat()}",
                style: TextStyle(
                  fontSize: AppSize.smallText,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[300] : Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountSection(UserCurrencyEntity transaction, bool isDark) {
    final totalAmount = transaction.price * transaction.amount;
    final isProfit = transaction.transactionType == TransactionTypeEnum.SELL;
    
    // Dark theme için renk ayarlaması
    final color = isProfit
        ? (isDark ? Colors.green.shade400 : DefaultColorPalette.vanillaGreen)
        : (isDark ? Colors.red.shade400 : DefaultColorPalette.errorRed);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(isDark ? 0.5 : 0.3),
              width: 1,
            ),
          ),
          child: Text(
            "${isProfit ? '+' : '-'}₺${totalAmount.toNumberWithTurkishFormat()}",
            style: TextStyle(
              color: color,
              fontSize: 12, // Biraz küçülttüm
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            GeneralConstants.dateFormat.format(transaction.buyDate),
            style: TextStyle(
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

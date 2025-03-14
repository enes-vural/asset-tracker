import 'package:asset_tracker/core/config/theme/extension/number_format_extension.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TransactionCardLVBWidget extends StatelessWidget {
  const TransactionCardLVBWidget({
    super.key,
    required this.entry,
  });

  final MapEntry<String, List<UserCurrencyEntityModel>> entry;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entry.value.length,
      itemBuilder: (context, index) {
        var transaction = entry.value[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          child: ListTile(
            title: Text(
              transaction.currencyCode,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
            subtitle: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount: ${transaction.amount}",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                        "Price: ₺${transaction.price.toNumberWithTurkishFormat()}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
                const Expanded(child: CustomSizedBox.empty()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "- ₺${(transaction.price * transaction.amount).toNumberWithTurkishFormat()}",
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    Text(DateFormat("dd MMMM").format(transaction.buyDate)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

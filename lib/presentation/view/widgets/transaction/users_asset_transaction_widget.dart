import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/core/constants/enums/widgets/transaction_card_desc_text_type_enums.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/number_format_extension.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/general/calculate_profit_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/widgets/loading_skeletonizer_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/transaction/transaction_card_description_text_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/transaction/transaction_card_lvb_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAssetTransactionWidget extends ConsumerStatefulWidget {
  const UserAssetTransactionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserAssetTransactionWidgetState();
}

class _UserAssetTransactionWidgetState
    extends ConsumerState<UserAssetTransactionWidget> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Veriyi aldıktan sonra loading state'i kapatacağız
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(dashboardViewModelProvider.notifier).showAssetsAsStatistic(ref);
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UserDataEntity? entity = ref.watch(appGlobalProvider.notifier).getUserData;
    List<UserCurrencyEntity>? allTransactions =
        (entity?.currencyList ?? []) + (entity?.soldCurrencyList ?? []);

    final viewModel = ref.watch(dashboardViewModelProvider);

    Map<String, List<UserCurrencyEntity>> groupedData = {};

    // Verileri gruplama işlemi
    // ignore: avoid_function_literals_in_foreach_calls
    allTransactions.forEach((UserCurrencyEntity transaction) {
      if (!groupedData.containsKey(transaction.currencyCode)) {
        groupedData[transaction.currencyCode] = [];
      }
      groupedData[transaction.currencyCode]?.add(transaction);
    });

    if (isLoading) {
      return const LoadingSkeletonizerWidget();
    }

    if (!isLoading) {
      return CustomPadding.largeHorizontal(
        widget: Container(
          decoration: CustomDecoration.roundBox(radius: AppSize.largeRadius),
          child: Column(
            spacing: AppSize.hugePadd,
            children: groupedData.entries
                .map((MapEntry<String, List<UserCurrencyEntity>> entry) {
              final CalculateProfitEntity? stats =
                  viewModel.calculateSelectedCurrencyTotalAmount(
                      ref, entry.key.toString());

              double quentities = entry.value
                  .where((e) => e.transactionType == TransactionTypeEnum.BUY)
                  .fold<double>(0.0, (prev, e) => prev + e.amount);

              // Her bir kategori için (örneğin ALTIN, DOLAR) başlık ve kartlar
              //TODO: Localization here
              return Column(
                spacing: 2.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomPadding.smallHorizontal(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${entry.key} (${quentities.toNumberWithTurkishFormat()})", // Kategori adı (ALTIN, DOLAR)
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "Transaction: ${entry.value.length}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Kategorinin altındaki işlemler (Card'lar)
                  _transactionCDescription(stats),
                  TransactionCardLVBWidget(entry: entry, viewModel: viewModel),
                ],
              );
            }).toList(),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  CustomPadding _transactionCDescription(CalculateProfitEntity? stats) {
    return CustomPadding.smallHorizontal(
      widget: Column(
        children: [
          TransactionCardDescriptionTextWidget(
            label: "Purchase",
            stats: stats?.purchasePriceTotal,
            type: TransactionCardDescriptionTextType.PURCHASE,
          ),
          TransactionCardDescriptionTextWidget(
            //LOCALIZATION HERE TODO:
            label: "Selling Price:",
            stats: stats?.latestPriceTotal,
            type: TransactionCardDescriptionTextType.SELL,
          ),
          TransactionCardDescriptionTextWidget(
            label: "Profit:",
            stats: stats?.profit,
            type: TransactionCardDescriptionTextType.PROFIT,
          ),
        ],
      ),
    );
  }
}

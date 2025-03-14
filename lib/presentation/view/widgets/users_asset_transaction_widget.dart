import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/number_format_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/usar_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserAssetTransactionWidget extends ConsumerStatefulWidget {
  const UserAssetTransactionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserAssetTransactionWidgetState();
}

class _UserAssetTransactionWidgetState
    extends ConsumerState<UserAssetTransactionWidget> {
  bool isLoading = true; // Yükleme durumunu kontrol etmek için bir flag ekledik

  @override
  void initState() {
    super.initState();
    // Veriyi aldıktan sonra loading state'i kapatacağız
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(dashboardViewModelProvider.notifier).showAssetsAsStatistic(ref);
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isLoading =
              false; // Yükleme tamamlandığında UI'yi yeniden güncelleriz
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UserDataEntity? entity = ref.watch(appGlobalProvider.notifier).getUserData;
    List<UserCurrencyEntityModel>? list = entity?.currencyList;

    final viewModel = ref.watch(dashboardViewModelProvider);

    // Veriler yüklenene kadar CircularProgressIndicator göster

    // Veriyi kategorilere göre gruplama
    Map<String, List<UserCurrencyEntityModel>> groupedData = {};

    // Verileri gruplama işlemi
    list?.forEach((transaction) {
      if (!groupedData.containsKey(transaction.currencyCode)) {
        groupedData[transaction.currencyCode] = [];
      }
      groupedData[transaction.currencyCode]?.add(transaction);
    });

    if (isLoading) {
      return Expanded(
        child: Skeletonizer(
          child: SizedBox(
            width: ResponsiveSize(context).screenWidth / 1.1,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 6,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (!isLoading) {
      return Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: CustomPadding.largeHorizontal(
            widget: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                spacing: AppSize.hugePadd,
                children: groupedData.entries.map((entry) {
                  double quentities = entry.value.fold<double>(
                      0.0,
                      (previousValue, element) =>
                          previousValue + element.amount);

                  // Her bir kategori için (örneğin ALTIN, DOLAR) başlık ve kartlar
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
                              "Available: ${entry.value.length}",
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
                      CustomPadding.smallHorizontal(
                        widget: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Purchase:"),
                                Text(
                                  "₺${entry.value.fold<double>(0.0, (previousValue, element) => previousValue + (element.price) * (element.amount)).toNumberWithTurkishFormat()}",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Sell Price:"),
                                Text(
                                  "₺${viewModel.calculateSelectedCurrencyTotalAmount(ref, entry.key.toString())?.latestPriceTotal.toNumberWithTurkishFormat()}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Profit:"),
                                Text(
                                  "₺${viewModel.calculateSelectedCurrencyTotalAmount(ref, entry.key.toString())?.profit.toNumberWithTurkishFormat()}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      ListView.builder(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Amount: ${transaction.amount}",
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                      Text(
                                          "Price: ₺${transaction.price.toNumberWithTurkishFormat()}",
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14)),
                                    ],
                                  ),
                                  const Expanded(child: CustomSizedBox.empty()),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "- ₺${(transaction.price * transaction.amount).toNumberWithTurkishFormat()}",
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 16),
                                      ),
                                      Text(DateFormat("dd MMMM")
                                          .format(transaction.buyDate)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}

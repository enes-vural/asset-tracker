import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/core/config/theme/extension/number_format_extension.dart';
import 'package:asset_tracker/core/constants/enums/widgets/dashboard_filters_enum.dart';
import 'package:asset_tracker/core/mixins/get_currency_icon_mixin.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/general/calculate_profit_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/widgets/loading_skeletonizer_widget.dart';
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
    extends ConsumerState<UserAssetTransactionWidget>
    with TickerProviderStateMixin, GetCurrencyIconMixin {
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(dashboardViewModelProvider.notifier).showAssetsAsStatistic(ref);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    UserDataEntity? entity = ref.watch(appGlobalProvider.notifier).getUserData;
    List<UserCurrencyEntity>? allTransactions =
        (entity?.currencyList ?? []) + (entity?.soldCurrencyList ?? []);

    final viewModel = ref.watch(dashboardViewModelProvider);

    Map<String, List<UserCurrencyEntity>> groupedData = {};

    // Verileri gruplama işlemi
    allTransactions.forEach((UserCurrencyEntity transaction) {
      if (!groupedData.containsKey(transaction.currencyCode) &&
          //filtreleme işlemleri
          ((currencyTypes[transaction.currencyCode] ==
                  viewModel.selectedFilter) ||
              viewModel.selectedFilter == DashboardFilterEnum.ALL)) {
        groupedData[transaction.currencyCode] = [];
      }
      groupedData[transaction.currencyCode]?.add(transaction);
    });

    if (isLoading) {
      return const LoadingSkeletonizerWidget();
    }

    if (groupedData.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomPadding.largeHorizontal(
          widget: Column(
            children: groupedData.entries
                .map((MapEntry<String, List<UserCurrencyEntity>> entry) {
              final CalculateProfitEntity? stats =
                  viewModel.calculateSelectedCurrencyTotalAmount(
                      ref, entry.key.toString());

              double quantities = entry.value
                  .where((e) => e.transactionType == TransactionTypeEnum.BUY)
                  .fold<double>(0.0, (prev, e) => prev + e.amount);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildEnhancedAssetCard(
                  entry: entry,
                  stats: stats,
                  quantities: quantities,
                  viewModel: viewModel,
                  isDark: isDark,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "Henüz işlem yok",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "İlk yatırımınızı yaparak başlayın",
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddTransactionDialog(isDark),
              icon: const Icon(Icons.add),
              label: const Text("İşlem Ekle"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: isDark ? Colors.blueGrey[700] : null,
                foregroundColor: isDark ? Colors.white : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedAssetCard({
    required MapEntry<String, List<UserCurrencyEntity>> entry,
    required CalculateProfitEntity? stats,
    required double quantities,
    required dynamic viewModel,
    required bool isDark,
  }) {
    final isProfit = (stats?.profit ?? 0) >= 0;
    final profitColor = isProfit ? Colors.green : Colors.red;

    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final borderColor = isDark
        ? Colors.grey[700]!.withOpacity(0.3)
        : Colors.grey.withOpacity(0.1);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black)
                .withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Header with asset info and profit indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    profitColor.withOpacity(isDark ? 0.15 : 0.1),
                    profitColor.withOpacity(isDark ? 0.08 : 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset(
                      getCurrencyIcon(entry.key),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Asset info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              setCurrencyLabel(entry.key),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.grey[700]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${entry.value.length} işlem",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey[300]
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${quantities.toNumberWithTurkishFormat()} birim",
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[300] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profit indicator
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: profitColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isProfit
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${isProfit ? '+' : ''}${((stats?.profit ?? 0) / (stats?.purchasePriceTotal ?? 1) * 100).toStringAsFixed(1)}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stats section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildEnhancedStatsRow(stats, isDark),
                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          "Sil",
                          Icons.remove_circle,
                          Colors.red[600]!,
                          () => _removeTransaction(entry.value.first),
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          "Sat",
                          Icons.sell_outlined,
                          Colors.red[600]!,
                          () => _routeTradeView(
                              false, ref, entry.key.getCurrencyTitle()),
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          "Al",
                          Icons.add_circle_outline,
                          Colors.green[600]!,
                          () => _routeTradeView(
                              true, ref, entry.key.getCurrencyTitle()),
                          isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Expandable transaction list
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                unselectedWidgetColor:
                    isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              child: ExpansionTile(
                title: Text(
                  "İşlem Geçmişi (${entry.value.length})",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                iconColor: isDark ? Colors.grey[400] : Colors.grey[600],
                collapsedIconColor:
                    isDark ? Colors.grey[400] : Colors.grey[600],
                children: [
                  TransactionCardLVBWidget(entry: entry, viewModel: viewModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedStatsRow(CalculateProfitEntity? stats, bool isDark) {
    final dividerColor = isDark ? Colors.grey[600] : Colors.grey[300];

    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            "Alış",
            stats?.purchasePriceTotal ?? 0,
            Icons.shopping_cart_outlined,
            Colors.blue,
            isDark,
          ),
        ),
        Container(
          width: 1,
          height: 40,
          color: dividerColor,
        ),
        Expanded(
          child: _buildStatItem(
            "Güncel",
            stats?.latestPriceTotal ?? 0,
            Icons.trending_up_outlined,
            Colors.orange,
            isDark,
          ),
        ),
        Container(
          width: 1,
          height: 40,
          color: dividerColor,
        ),
        Expanded(
          child: _buildStatItem(
            "Kar/Zarar",
            stats?.profit ?? 0,
            (stats?.profit ?? 0) >= 0
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            (stats?.profit ?? 0) >= 0 ? Colors.green : Colors.red,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      String label, double value, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[300] : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "₺${value.toNumberWithTurkishFormat()}",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color,
      VoidCallback onPressed, bool isDark) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: color),
      label: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(isDark ? 0.5 : 0.3)),
        ),
        backgroundColor: isDark ? color.withOpacity(0.1) : Colors.transparent,
      ),
    );
  }

  void _showAddTransactionDialog(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Yeni İşlem Ekle",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            // Transaction form here
          ],
        ),
      ),
    );
  }

  void _routeTradeView(bool isBuy, WidgetRef ref, String currencyLabel) {
    ref
        .read(dashboardViewModelProvider)
        .routeTradeView(ref, isBuy, currencyLabel);
  }

  void _removeTransaction(UserCurrencyEntity transaction) {
    ref.read(dashboardViewModelProvider).removeTransaction(ref, transaction);
  }
}

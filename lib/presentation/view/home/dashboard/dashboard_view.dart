import 'package:asset_tracker/core/config/theme/extension/number_format_extension.dart';
import 'package:asset_tracker/core/constants/enums/widgets/app_pages_enum.dart';
import 'package:asset_tracker/core/helpers/dialog_helper.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/home/widgets/unauthorized_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/presentation/view/home/widgets/balance_text_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/custom_pie_chart_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/transaction/users_asset_transaction_widget.dart';

@RoutePage()
class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  bool _showScrollToTop = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );

    _scrollController.addListener(_onScroll);
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (_scrollController.offset <= 200 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(dashboardViewModelProvider);
    final authState = ref.watch(authGlobalProvider);

    EasyDialog.showDialogOnProcess(context, ref, dashboardViewModelProvider);

    return PopScope(
      canPop: viewModel.canPop,
      child: authState.getCurrentUser?.user != null
          ? _modernScaffold(context)
          : const UnAuthorizedWidget(page: UnAuthorizedPage.WALLET),
    );
  }

  Scaffold _modernScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Modern App Bar with Gradient

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Quick Stats Cards
                _buildQuickStatsSection(ref),

                // Portfolio Overview
                _buildPortfolioSection(),

                // Available Balance
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: availableTextWidget(),
                ),

                // Balance Display
                const BalanceTextWidget(),

                const CustomSizedBox.hugeGap(),

                // Enhanced Transaction Widget
                const EnhancedUserAssetTransactionWidget(),

                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ],
      ),

      // Floating Action Buttons
      floatingActionButton: _buildFloatingActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildQuickStatsSection(WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickStatCard(
                title: "Kar",
                value: "₺" +
                    ref
                        .watch(appGlobalProvider)
                        .getProfit
                        .toNumberWithTurkishFormat()
                        .toString(),
                icon: Icons.trending_up,
                color: Colors.green,
                percentage: "%" +
                    ref
                        .watch(appGlobalProvider)
                        .getPercentProfit
                        .toStringAsFixed(2)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickStatCard(
              title: "Toplam Yatırım",
              value: "₺" +
                  ref
                      .read(appGlobalProvider)
                      .getUserBalance
                      .toNumberWithTurkishFormat(),
              icon: Icons.account_balance_wallet,
              color: Colors.blue,
              percentage: "",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String percentage,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              if (percentage.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    percentage,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Portföy Dağılımı",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: PieChartWidget(),
            ),
            CustomSizedBox.hugeGap(),
            CustomSizedBox.hugeGap(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Scroll to top button
        if (_showScrollToTop)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FloatingActionButton.small(
              onPressed: _scrollToTop,
              backgroundColor: Colors.grey[700],
              child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
            ),
          ),

        // Quick actions
        ScaleTransition(
          scale: _fabAnimation,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.extended(
                onPressed: () => ref
                    .read(appGlobalProvider)
                    .changeMenuNavigationIndex(AppPagesEnum.TRADE.pageIndex),
                backgroundColor: Colors.green[600],
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Al", style: TextStyle(color: Colors.white)),
                heroTag: "buy",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Text availableTextWidget() {
    return Text(
      LocaleKeys.dashboard_availableBalance.tr(),
      style: TextStyle(
        color: DefaultColorPalette.grey500,
        fontSize: AppSize.mediumText,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// Enhanced Transaction Widget
class EnhancedUserAssetTransactionWidget extends ConsumerStatefulWidget {
  const EnhancedUserAssetTransactionWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnhancedUserAssetTransactionWidgetState();
}

class _EnhancedUserAssetTransactionWidgetState
    extends ConsumerState<EnhancedUserAssetTransactionWidget> {
  String _selectedFilter = "Tümü";
  final List<String> _filters = [
    "Tümü",
    "Altın",
    "Döviz",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with filters
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Varlıklarım",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showSortOptions(),
                      icon: const Icon(Icons.sort),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Filter chips
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = filter == _selectedFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedFilter = filter);
                          },
                          backgroundColor: Colors.grey[100],
                          selectedColor:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[700],
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Transaction List with enhanced cards
          const UserAssetTransactionWidget(),
        ],
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Sıralama",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text("Kar/Zarar'a göre"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("Tarihe göre"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text("Miktara göre"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:asset_tracker/core/config/theme/extension/number_format_extension.dart';
import 'package:asset_tracker/core/constants/enums/widgets/app_pages_enum.dart';
import 'package:asset_tracker/core/helpers/dialog_helper.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/home/widgets/dashboard_filter_widget.dart';
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
    final viewModel = ref.read(dashboardViewModelProvider);
    final isAuthorized =
        ref.watch(authGlobalProvider.select((value) => value.isUserAuthorized));

    EasyDialog.showDialogOnProcess(context, ref, dashboardViewModelProvider);

    return PopScope(
      canPop: viewModel.canPop,
      child: isAuthorized
          ? _modernScaffold(context)
          //const causes localization issue
          // ignore: prefer_const_constructors
          : UnAuthorizedWidget(page: UnAuthorizedPage.WALLET),
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
                const CustomSizedBox.smallGap(),
                availableTextWidget(),
                // Balance Display
                const BalanceTextWidget(),

                const CustomSizedBox.hugeGap(),

                // Enhanced Transaction Widget
                // ignore: prefer_const_constructors
                EnhancedUserAssetTransactionWidget(),

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
                title: LocaleKeys.dashboard_profit.tr(),
                value:
                    "₺${ref.watch(appGlobalProvider).getProfit.toNumberWithTurkishFormat()}",
                icon: Icons.trending_up,
                color: Colors.green,
                percentage:
                    "%${ref.watch(appGlobalProvider).getPercentProfit.toStringAsFixed(2)}"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickStatCard(
              title: LocaleKeys.dashboard_totalBalance.tr(),
              value:
                  "₺${ref.watch(appGlobalProvider).getUserBalance.toNumberWithTurkishFormat()}",
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
    // Percentage negatif mi kontrol et
    bool isNegative = value.contains('-');

    // Negatifse renkleri ve ikonu değiştir
    Color finalColor = isNegative ? Colors.red : color;
    IconData finalIcon = isNegative ? Icons.trending_down : icon;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.white.withOpacity(0.05),
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
              Icon(finalIcon, color: finalColor, size: 24),
              if (percentage.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: finalColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    percentage,
                    style: TextStyle(
                      color: finalColor,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.dashboard_portfolio.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 200,
              child: PieChartWidget(),
            ),
            const CustomSizedBox.hugeGap(),
            const CustomSizedBox.hugeGap(),
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
                label: Text(LocaleKeys.dashboard_buyFloatingButton.tr(),
                    style: const TextStyle(color: Colors.white)),
                heroTag: LocaleKeys.dashboard_buyFloatingButton.tr(),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.white.withOpacity(0.05),
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
          // Header with filters - Bu kısım optimize edildi
          const FilterSection(),

          // Transaction List with enhanced cards
          UserAssetTransactionWidget(),
        ],
      ),
    );
  }
}

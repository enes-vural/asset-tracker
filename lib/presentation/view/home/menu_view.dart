import 'package:asset_tracker/core/config/theme/extension/asset_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/constants/asset_constant.dart';
import 'package:asset_tracker/core/constants/database/transaction_type_enum.dart';
import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/buy_currency_entity.dart';
import 'package:asset_tracker/presentation/view/home/dashboard/dashboard_view.dart';
import 'package:asset_tracker/presentation/view/home/home_view.dart';
import 'package:asset_tracker/presentation/view/home/trade/trade_view.dart';
import 'package:auto_route/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/widgets/custom_icon.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/home/widgets/tabbar_icon_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/home_view_search_field_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/home_view_swap_button_widget.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';

@RoutePage()
class MenuView extends ConsumerStatefulWidget {
  const MenuView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuViewState();
}

class _MenuViewState extends ConsumerState<MenuView> {
  int _currentIndex = 0;

  Future<void> callData() async =>
      await ref.read(homeViewModelProvider).getData(ref);

  Future<void> getErrorStream() async => await ref
      .read(homeViewModelProvider)
      .getErrorStream(parentContext: context);

  void initHomeView() =>
      ref.read(homeViewModelProvider.notifier).initHomeView();

  List<dynamic> pages = [
    const HomeView(),
    const TradeView(currecyCode: "", price: null),
    const DashboardView(),
  ];

  @override
  void initState() {
    //initialize all streams when page starts
    initHomeView();
    callData();
    getErrorStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = ref.watch(homeViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: DefaultColorPalette.grey100,
        backgroundColor: DefaultColorPalette.grey100,
        shadowColor: DefaultColorPalette.vanillaBlack,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const CircleAvatar(
          backgroundColor: Colors.transparent,
          child: CustomIcon.drawer(),
        ),
        centerTitle: true,
        title: SizedBox(
          height: AppSize.largeIcon * 2,
          child: Image.asset(AssetConstant.mainLogo.toPng()),
        ),
      ),
      body: SizedBox(
        height: ResponsiveSize(context).screenHeight * 0.8,
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(viewModel, context),
    );
  }

  Scaffold oldScaffold(HomeViewModel viewModel, BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultColorPalette.grey100,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                surfaceTintColor: DefaultColorPalette.grey100,
                backgroundColor: DefaultColorPalette.grey100,
                shadowColor: DefaultColorPalette.vanillaBlack,
                elevation: 0,
                scrolledUnderElevation: 0,
                floating: true,
                snap: true,
                pinned: false,
                expandedHeight: 60,
                leading: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: CustomIcon.drawer(),
                ),
                centerTitle: true,
                title: SizedBox(
                  height: AppSize.largeIcon * 2,
                  child: Image.asset(AssetConstant.mainLogo.toPng()),
                ),
                actions: const [
                  // Actions kaldırıldı
                ],
              ),
            ],
          ),
          Container(
            child: pages[_currentIndex],
          ),
          _homeClearButtonWidget(viewModel),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(viewModel, context),
    );
  }

  Widget _buildBottomNavigationBar(
      HomeViewModel viewModel, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: DefaultColorPalette.mainBlue,
        unselectedItemColor: DefaultColorPalette.grey400,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Ana Sayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: "Cüzdan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: "Al-Sat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(
      int index, HomeViewModel viewModel, BuildContext context) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Ana sayfa - mevcut sayfa
        break;
      case 1:
        // Cüzdan sayfası
        _currentIndex = 1;

        break;
      case 2:
        // Trade sayfası
        _currentIndex = 2;
        //_handleTradeAction();
        break;
      case 3:
        // Profil sayfası
        _handleProfileAction();
        break;
    }
  }

  void _handleProfileAction() {
    // Profil sayfasına yönlendirme kodu buraya gelecek
    debugPrint("Profile page navigation");
  }

  Positioned _homeClearButtonWidget(HomeViewModel viewModel) {
    return Positioned(
      bottom: 20, // Bottom navigation bar için yüksekliği artırdık
      left: 20,
      child: Row(
        children: [
          HomeViewSearchFieldWidget(viewModel: viewModel),
          const CustomSizedBox.mediumWidth(),
          HomeViewSwapButtonWidget(
            onTap: () {
              viewModel.clearText();
            },
          ),
        ],
      ),
    );
  }

  TabBarIconWidget _tabBarButtonDownloadWidget() {
    return TabBarIconWidget(
        icon: IconDataConstants.download,
        onTap: () {
          var actions = ref.read(cacheUseCaseProvider).getOfflineActions();

          debugPrint("Actions: $actions");
          for (var action in actions) {
            debugPrint("Action Type: ${action.type}");
            debugPrint("Action Status: ${action.status}");
            debugPrint("Action Params: ${action.params}");
          }
        });
  }

  TabBarIconWidget _tabBarButtonSendWidget() => TabBarIconWidget(
      icon: Icons.send,
      onTap: () {
        final buyModel = BuyCurrencyEntity(
          currency: "USDTRY",
          amount: 5,
          price: 10000,
          date: DateTime(DateTime.april, 2023),
          userId: ref.read(authGlobalProvider).getCurrentUserId,
          transactionType: TransactionTypeEnum.BUY,
        );

        ref.read(cacheUseCaseProvider).saveOfflineAction(
              Tuple2(OfflineActionType.BUY_ASSET, buyModel),
            );
      });

  TabBarIconWidget _tabBarButtonTradeWidget(
      HomeViewModel viewModel, BuildContext context) {
    return TabBarIconWidget(
        icon: IconDataConstants.dollar,
        onTap: () {
          ref.read(cacheUseCaseProvider).clearAllOfflineActions();
          //viewModel.routeTradePage(context, null);
        });
  }

  TabBarIconWidget _tabBarButtonWalletWidget(
      HomeViewModel viewModel, BuildContext context) {
    return TabBarIconWidget(
        icon: IconDataConstants.wallet,
        onTap: () {
          viewModel.routeWalletPage(context);
        });
  }

  Text _exploreAssetsText() {
    return Text(
      //TODO:
      LocaleKeys.dashboard_exploreAssets.tr(),
      style: TextStyle(
        color: DefaultColorPalette.grey500,
        fontSize: AppSize.mediumText,
      ),
    );
  }

  IconButton exitAppIconButton(VoidCallback fn) => IconButton(
        onPressed: fn,
        icon: CustomIcon.exit(),
      );
}

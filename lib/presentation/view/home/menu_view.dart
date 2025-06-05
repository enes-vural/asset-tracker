import 'package:asset_tracker/core/config/theme/extension/asset_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/constants/asset_constant.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/presentation/view/home/dashboard/dashboard_view.dart';
import 'package:asset_tracker/presentation/view/home/home_view.dart';
import 'package:asset_tracker/presentation/view/home/trade/trade_view.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/widgets/custom_icon.dart';
import 'package:asset_tracker/injection.dart';
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
    const DashboardView(),
    const TradeView(currecyCode: "", price: null),
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
    final authState = ref.watch(authGlobalProvider);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: DefaultColorPalette.grey100,
        backgroundColor: DefaultColorPalette.grey100,
        shadowColor: DefaultColorPalette.vanillaBlack,
        elevation: 0,
        scrolledUnderElevation: 0,
        actionsPadding: const CustomEdgeInstets.mediumHorizontal(),
        leading: const CircleAvatar(
          backgroundColor: Colors.transparent,
          child: CustomIcon.drawer(),
        ),
        centerTitle: true,
        title: SizedBox(
          height: AppSize.largeIcon * 2,
          child: Image.asset(AssetConstant.mainLogo.toPng()),
        ),
        actions: [
          authState.getCurrentUser?.user != null
              ? exitAppIconButton(() async => viewModel.signOut(ref, context))
              : Text(
                  "Giriş Yap",
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: DefaultColorPalette.mainBlue,
                  ),
                ),
        ],
      ),
      body: SizedBox(
        height: ResponsiveSize(context).screenHeight,
        child: pages[_currentIndex],
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

  IconButton exitAppIconButton(VoidCallback fn) => IconButton(
        onPressed: fn,
        icon: CustomIcon.exit(),
      );
}

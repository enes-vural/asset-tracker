import 'package:asset_tracker/core/config/theme/extension/asset_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/constants/asset_constant.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/routers/app_router.gr.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/presentation/view/home/dashboard/dashboard_view.dart';
import 'package:asset_tracker/presentation/view/home/home_view.dart';
import 'package:asset_tracker/presentation/view/home/settings/settings_view.dart';
import 'package:asset_tracker/presentation/view/home/trade/trade_view.dart';
import 'package:asset_tracker/presentation/view/home/widgets/menu_bottom_navigation_bar_widget.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/widgets/custom_icon.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class MenuView extends ConsumerStatefulWidget {
  const MenuView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuViewState();
}

class _MenuViewState extends ConsumerState<MenuView> {
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
    const TradeView(currencyCode: DefaultLocalStrings.emptyText, price: null),
    const SettingsView(),
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
    int menuIndex = ref.watch(appGlobalProvider).menuNavigationIndex;

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
          height: 100.h,
          width: 100.w,
          child: Image.asset(
            AssetConstant.mainLogo.toPng(),
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          authState.getCurrentUser?.user != null
              ? const CustomSizedBox.empty()
              : TextButton(
                  onPressed: () => viewModel.routeSignInPage(context),
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: DefaultColorPalette.mainBlue,
                    ),
                  ),
                ),
        ],
      ),
      body: SizedBox(
        height: ResponsiveSize(context).screenHeight,
        child: pages[menuIndex],
      ),
      bottomNavigationBar: const MenuBottomNavigationBarWidget(),
    );
  }

  IconButton exitAppIconButton(VoidCallback fn) => IconButton(
        onPressed: fn,
        icon: CustomIcon.exit(),
      );
}

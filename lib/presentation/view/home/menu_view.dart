import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/presentation/view/home/dashboard/dashboard_view.dart';
import 'package:asset_tracker/presentation/view/home/home_view.dart';
import 'package:asset_tracker/presentation/view/home/settings/settings_view.dart';
import 'package:asset_tracker/presentation/view/home/trade/trade_view.dart';
import 'package:asset_tracker/presentation/view/home/widgets/parota_logo_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/menu_bottom_navigation_bar_widget.dart';
import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/widgets/custom_icon.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';

@RoutePage()
class MenuView extends ConsumerStatefulWidget {
  const MenuView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuViewState();
}

class _MenuViewState extends ConsumerState<MenuView>
    with TickerProviderStateMixin {
  // Future<void> callData() async =>
  //     await ref.read(homeViewModelProvider).getData(ref);

  // Future<void> getErrorStream() async => await ref
  //     .read(homeViewModelProvider)
  //     .getErrorStream(parentContext: context);

  void listenSocketData() =>
      ref.read(homeViewModelProvider).listenToSocketData(ref);

  List<dynamic> pages = [
    const HomeView(),
    const DashboardView(),
    const TradeView(currencyCode: DefaultLocalStrings.emptyText, price: null),
    const SettingsView(),
  ];

  @override
  void initState() {
    // callData();
    // getErrorStream();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listenSocketData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = ref.watch(homeViewModelProvider);
    final authState = ref.watch(authGlobalProvider);
    int currentIndex = ref.watch(appGlobalProvider).menuNavigationIndex;

    return PopScope(
      canPop: false, // Varsayılan pop davranışını engelle
      onPopInvoked: (didPop) async {
        if (didPop) return;

        // Eğer Home tab'inde değilsek, Home'a dön
        if (currentIndex != 0) {
          ref.read(appGlobalProvider).changeMenuNavigationIndex(0);
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          //surfaceTintColor: DefaultColorPalette.grey100,
          //backgroundColor: DefaultColorPalette.grey100,
          //shadowColor: DefaultColorPalette.vanillaBlack,
          elevation: 0,
          scrolledUnderElevation: 0,
          actionsPadding: const CustomEdgeInstets.mediumHorizontal(),
          centerTitle: true,
          title: const PaRotaLogoWidget(),
          actions: [
            authState.getCurrentUser?.user != null
                ? const CustomSizedBox.empty()
                : TextButton(
                    onPressed: () => viewModel.routeSignInPage(context),
                    child: Text(
                      LocaleKeys.auth_signIn.tr(),
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: DefaultColorPalette.mainBlue,
                      ),
                    ),
                  ),
          ],
        ),
        body: IndexedStack(
          index: ref.watch(appGlobalProvider).menuNavigationIndex,
          children: [
            ...pages,
          ],
        ),
        bottomNavigationBar: const MenuBottomNavigationBarWidget(),
      ),
    );
  }

  IconButton exitAppIconButton(VoidCallback fn) => IconButton(
        onPressed: fn,
        icon: CustomIcon.exit(),
      );
}

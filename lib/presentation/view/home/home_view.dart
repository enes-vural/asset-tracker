import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/routers/app_router.gr.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/common/user_email_text_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/balance_profit_text_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/balance_text_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/currency_card_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/tabbar_icon_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/welcome_card_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/home_view_search_field_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/home_view_swap_button_widget.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  //async function to call data
  Future<void> callData() async =>
      await ref.read(homeViewModelProvider).getData(ref);

  Future<void> getErrorStream() async => await ref
      .read(homeViewModelProvider)
      .getErrorStream(parentContext: context);

  void initHomeView() =>
      ref.read(homeViewModelProvider.notifier).initHomeView();

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
      backgroundColor: DefaultColorPalette.grey100,
      appBar: AppBar(
        surfaceTintColor: DefaultColorPalette.grey100,
        backgroundColor: DefaultColorPalette.grey100,
        shadowColor: DefaultColorPalette.vanillaBlack,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(Icons.person),
        ),
        actions: [
          exitAppIconButton(),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: CustomPadding.largeHorizontal(
              widget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const UserEmailTextWidget(),
                  const CustomSizedBox.hugeGap(),
                  const BalanceTextWidget(),
                  const BalanceProfitTextWidget(),
                  const CustomSizedBox.hugeGap(),
                  Row(
                    children: [
                      TabBarIconWidget(
                          icon: Icons.wallet,
                          onTap: () {
                            viewModel.routeWalletPage(context);
                          }),
                      const CustomSizedBox.mediumWidth(),
                      TabBarIconWidget(
                          icon: Icons.attach_money_rounded,
                          onTap: () {
                            viewModel.routeTradePage(context, null);
                          }),
                      const CustomSizedBox.mediumWidth(),
                      TabBarIconWidget(icon: Icons.send, onTap: () {}),
                      const CustomSizedBox.mediumWidth(),
                      TabBarIconWidget(
                          icon: Icons.download_rounded, onTap: () {}),
                    ],
                  ),
                  const CustomSizedBox.hugeGap(),
                  const WelcomeCardWidget(),
                  const CustomSizedBox.hugeGap(),
                  _exploreAssetsText(),
                  // ignore: prefer_const_constructors
                  CurrencyCardListWidget(),
                  const CustomSizedBox.hugeGap(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: Row(
              children: [
                HomeViewSearchFieldWidget(viewModel: viewModel),
                const CustomSizedBox.mediumWidth(),
                HomeViewSwapButtonWidget(
                  onTap: () {
                    //TODO: swap to trade page
                    viewModel.swapToTradePage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text _exploreAssetsText() {
    return Text(
      "Explore Assets",
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 15,
      ),
    );
  }

  IconButton exitAppIconButton() => IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.exit_to_app,
        color: DefaultColorPalette.grey500,
      ));

  IconButton pushWalletIconButton() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.wallet,
        color: DefaultColorPalette.grey400,
      ),
    );
  }

  IconButton pushTradePageIconButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Routers.instance.pushWithInfo(
          context,
          TradeRoute(currecyCode: DefaultLocalStrings.emptyText),
        );
      },
      icon: Icon(
        Icons.attach_money,
        color: DefaultColorPalette.grey400,
      ),
    );
  }

}

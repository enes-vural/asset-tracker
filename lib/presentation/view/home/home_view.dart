// ignore_for_file: prefer_const_constructors

import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/widgets/custom_align.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/home/widgets/balance_profit_text_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/balance_text_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/currency_card_widget.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';

@RoutePage()
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  Future<void> callData() async =>
      await ref.read(homeViewModelProvider).getData(ref);

  Future<void> getErrorStream() async => await ref
      .read(homeViewModelProvider)
      .getErrorStream(parentContext: context);

  @override
  void initState() {
    callData();
    getErrorStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authGlobalProvider);
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: CustomPadding.largeHorizontal(
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //const UserEmailTextWidget(),
                      //const CustomSizedBox.hugeGap(),
                      BalanceTextWidget(),
                      BalanceProfitTextWidget(),
                      //if user is not authorized show _signInText Widget
                      //else return sizedbox with no volume.
                      authState.getCurrentUser?.user == null
                          ? _signInText()
                          : const CustomSizedBox.empty(),
                      const CustomSizedBox.mediumGap(),
                      _dateTimeTextWidget(),
                      const CustomSizedBox.smallGap(),

                      const CurrencyListWidget(),
                      const CustomSizedBox.hugeGap(),
                      // Bottom navigation için ekstra boşluk
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  CustomPadding _dateTimeTextWidget() {
    return CustomPadding.smallHorizontal(
      widget: CustomAlign.centerRight(
        child: Text(
          "🕙︎${ref.watch(appGlobalProvider).globalAssets?[0].tarih.split(' ')[1] ?? ""}",
          style: CustomTextStyle.greyColorManrope(context, AppSize.smallText),
        ),
      ),
    );
  }

  Text _signInText() {
    return Text(
      "PaRota ile altın ve dövizlerinizi kolayca takip etmek için giriş yapın.",
      style: CustomTextStyle.greyColorManrope(context, AppSize.small2Text),
    );
  }
}

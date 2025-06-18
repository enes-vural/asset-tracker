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
  late ScrollController _scrollController;
  bool _isAtTop = true;

  Future<void> callData() async =>
      await ref.read(homeViewModelProvider).getData(ref);

  Future<void> getErrorStream() async => await ref
      .read(homeViewModelProvider)
      .getErrorStream(parentContext: context);

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    callData();
    getErrorStream();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      _isAtTop = _scrollController.offset <= 100;
    });
  }

  void _scrollToTopOrBottom() {
    if (_isAtTop) {
      // Aşağıya scroll
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    } else {
      // Yukarıya scroll
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authGlobalProvider);
    
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
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
                      const CustomSizedBox.hugeGap(),
                      const CustomSizedBox.hugeGap(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTopOrBottom,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Icon(
            _isAtTop ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
            key: ValueKey(_isAtTop),
            color: Colors.white,
          ),
        ),
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

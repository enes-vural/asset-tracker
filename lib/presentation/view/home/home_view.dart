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

@RoutePage()
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;
  late FocusNode _searchFocusNode;

  bool _isSearchOpen = false;

  Future<void> callData() async =>
      await ref.read(homeViewModelProvider).getData(ref);

  Future<void> getErrorStream() async => await ref
      .read(homeViewModelProvider)
      .getErrorStream(parentContext: context);

  Future<void> initalizeVM() async =>
      await ref.read(homeViewModelProvider).initHomeView();

  @override
  void initState() {
    _scrollController = ScrollController();
    _searchFocusNode = FocusNode();

    initalizeVM();
    _searchAnimationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );

    // Animation listener - animasyon bitince focus ver
    _searchAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isSearchOpen) {
        // Küçük bir delay ile focus ver (animasyon tamamen bitsin diye)
        Future.delayed(Duration(milliseconds: 50), () {
          if (mounted) {
            _searchFocusNode.requestFocus();
          }
        });
      }
    });

    callData();
    getErrorStream();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchAnimationController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchOpen = !_isSearchOpen;
    });

    if (_isSearchOpen) {
      _searchAnimationController.forward();
    } else {
      _searchAnimationController.reverse();
      _searchFocusNode.unfocus(); // Arama kapanırken focus'u kaldır
      // ViewModel'den text'i temizle
      ref.read(homeViewModelProvider).clearText();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authGlobalProvider);
    final viewModel = ref.read(homeViewModelProvider);

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
                      // Animated Search Bar
                      AnimatedBuilder(
                        animation: _searchAnimation,
                        builder: (context, child) {
                          return SizeTransition(
                            sizeFactor: _searchAnimation,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top + 16,
                                bottom: 16,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outline
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.6),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: viewModel.searchBarController,
                                      focusNode: _searchFocusNode,
                                      decoration: InputDecoration(
                                        hintText: "Döviz veya altın ara...",
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                    ),
                                    onPressed: () {
                                      viewModel.clearText();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
        onPressed: _toggleSearch,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 150),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return RotationTransition(
              turns: animation,
              child: child,
            );
          },
          child: Icon(
            _isSearchOpen ? Icons.close : Icons.search,
            key: ValueKey(_isSearchOpen),
            color: Theme.of(context).colorScheme.onPrimary,
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

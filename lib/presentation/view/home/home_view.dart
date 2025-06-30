// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison
import 'dart:async';

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/widgets/custom_align.dart';
import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/home/widgets/balance_profit_text_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/balance_text_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/currency_card_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  Timer? _skeletonTimer;
  bool _showSkeleton = true;

  bool _isSearchOpen = false;

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
    _skeletonTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showSkeleton = false;
        });
      }
    });

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

    bool isDataLoaded = ref.read(appGlobalProvider).globalAssets != null &&
        ref.read(appGlobalProvider).globalAssets!.isNotEmpty;
    bool isLoading = !isDataLoaded || _showSkeleton;

    return Skeletonizer(
      enabled: isLoading,
      child: Scaffold(
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
                                        controller:
                                            viewModel.searchBarController,
                                        focusNode: _searchFocusNode,
                                        decoration: InputDecoration(
                                          hintText:
                                              LocaleKeys.home_searchText.tr(),
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
      ),
    );
  }

  CustomPadding _dateTimeTextWidget() {
    return CustomPadding.smallHorizontal(
      widget: CustomAlign.centerRight(
        child: Builder(
          builder: (context) {
            final globalAssets = ref.watch(appGlobalProvider).globalAssets;
            if (globalAssets == null || globalAssets.isEmpty) {
              return CustomSizedBox.empty();
            }

            try {
              final tarihParts = globalAssets[0].tarih.split(' ');
              final saat = tarihParts != null && tarihParts.length > 1
                  ? tarihParts[1]
                  : null;
              if (saat == null || saat.isEmpty) {
                return CustomSizedBox.empty();
              }

              return Text(
                "🕙︎$saat",
                style: CustomTextStyle.greyColorManrope(
                    context, AppSize.smallText),
              );
            } catch (e) {
              return CustomSizedBox.empty();
            }
          },
        ),
      ),
    );
  }

  Text _signInText() {
    return Text(
      LocaleKeys.home_homeDesc.tr(),
      style: CustomTextStyle.greyColorManrope(context, AppSize.small2Text),
    );
  }
}

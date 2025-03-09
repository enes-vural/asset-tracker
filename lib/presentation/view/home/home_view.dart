import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/routers/app_router.gr.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/widgets/search_form_widget.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:rxdart/rxdart.dart';
import '../widgets/currency_card_widget.dart';

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
        backgroundColor: DefaultColorPalette.grey100,
        title: Text(LocaleKeys.app_title.tr()),
        shadowColor: DefaultColorPalette.vanillaBlack,
        elevation: 5,
        leading: exitAppIconButton(),
        actions: [
          pushTradePageIconButton(context),
          pushWalletIconButton(),
        ],
      ),
      body: Center(
        child: CustomPadding.largeHorizontal(
          widget: Column(
            children: [
              CustomPadding.mediumTop(
                widget: SearchBarWidget(
                  searchBarController: viewModel.searchBarController,
                  onChangedFn: null,
                ),
              ),
              SizedBox(
                height: ResponsiveSize(context).screenHeight.toPercent(75),
                width: ResponsiveSize(context).screenWidth,
                child: StreamBuilder2(
                  streams: StreamTuple2(
                      ref.read(appGlobalProvider.notifier).getDataStream ??
                          viewModel.getEmptyStream,
                      viewModel.searchBarStreamController ??
                          viewModel.getEmptyStream),
                  initialData: InitialDataTuple2(null, null),
                  builder: (context, snapshots) {
                    // Stream henüz aktif değilse veya veriler yoksa, loading widget'ı göster
                    if (snapshots.snapshot1.connectionState !=
                        ConnectionState.active) {
                      return loadingIndicatorWidget();
                    }

                    if (!snapshots.snapshot1.hasData ||
                        snapshots.snapshot1.data?[0] == null) {
                      return loadingTextWidget();
                    }

                    List<CurrencyEntity>? data = snapshots.snapshot1.data;
                    data = viewModel.filterCurrencyData(
                        data,
                        snapshots.snapshot2.data ??
                            DefaultLocalStrings.emptyText);
                    // İkinci stream'in verisini al (Search bar'dan gelen veri)

                    // Güncellenmiş verileri kullanarak listview'i render et
                    return ListView.builder(
                      itemCount: data?.length ?? 0,
                      itemBuilder: (context, index) {
                        CurrencyWidgetEntity currency =
                            CurrencyWidgetEntity.fromCurrency(data![index]);
                        return CurrencyCardWidget(
                          currency: currency,
                          onTap: () {
                            viewModel.routeTradePage(context, currency.entity);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconButton exitAppIconButton() =>
      IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app));

  IconButton pushWalletIconButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.wallet),
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
      icon: const Icon(Icons.attach_money),
    );
  }

  Center loadingTextWidget() => Center(child: Text(LocaleKeys.home_wait.tr()));
  Center loadingIndicatorWidget() =>
      const Center(child: CircularProgressIndicator());
}

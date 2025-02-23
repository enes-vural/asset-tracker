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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      await ref.read(homeViewModelProvider).getData();

  Future<void> getErrorStream() async => await ref
      .read(homeViewModelProvider)
      .getErrorStream(parentContext: context);

  @override
  void initState() {
    //initialize all streams when page starts
    callData();
    getErrorStream();
    super.initState();
  }

  //TODO: Dispose method need for discard stream after navigate to another page

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = ref.watch(homeViewModelProvider);
    return Scaffold(
      backgroundColor: DefaultColorPalette.grey100,
      appBar: AppBar(
        backgroundColor: DefaultColorPalette.grey100,
        title: Text(LocaleKeys.app_title.tr()),
        shadowColor: Colors.black,
        elevation: 5,

        leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app)),
        actions: [
          IconButton(
            onPressed: () {
              Routers.instance.pushWithInfo(
                context,
                TradeRoute(currecyCode: ""),
              );
            },
            icon: const Icon(Icons.attach_money),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.wallet),
          ),
        ],
      ),
      body: Center(
        child: CustomPadding.largeHorizontal(
          widget: Column(
            children: [
              CustomPadding.mediumTop(
                widget: SearchBarWidget(
                  searchBarController: viewModel.searchBarController,
                ),
              ),
              SizedBox(
                height: ResponsiveSize(context).screenHeight.toPercent(75),
                width: ResponsiveSize(context).screenWidth,
                child: StreamBuilder(
                  stream: viewModel.getStream(),
                  builder: (context, snapshot) {
                    //Bir daha ek provider ile klavyenin girdisi ile buildi her tuş girişinde tetiklemek yerine
                    //her 2 saniyede bir zaten bu field stream socket ten dolayı yenileniyor.
                    //o zaman direkt olarak klavye filterini de burada yaparak
                    //tasaruf yapabiliriz.
                    if (snapshot.connectionState != ConnectionState.active) {
                      return loadingIndicatorWidget();
                    }

                    if (!snapshot.hasData) {
                      return loadingTextWidget();
                    }

                    List<CurrencyEntity>? data =
                        viewModel.filterCurrencyData(snapshot.data);

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        CurrencyWidgetEntity currency =
                            CurrencyWidgetEntity.fromCurrency(data[index]);
                        return CurrencyCardWidget(
                          currency: currency,
                          onTap: () {
                            debugPrint("Clicked on me");
                            Routers.instance.pushWithInfo(context,
                                TradeRoute(currecyCode: currency.code));
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

  Center loadingTextWidget() => Center(child: Text(LocaleKeys.home_wait.tr()));
  Center loadingIndicatorWidget() =>
      const Center(child: CircularProgressIndicator());
}

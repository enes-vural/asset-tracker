import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
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
  void callData() async => await ref.read(homeViewModelProvider).getData();

  @override
  void initState() {
    //initialize all streams when page starts
    callData();
    super.initState();
  }

  //TODO: Dispose method need for discard stream after navigate to another page

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = ref.watch(homeViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.app_title.tr())),
      body: Center(
        child: TextButton(
          onPressed: () {},
          child: CustomPadding.largeHorizontal(
            widget: SizedBox(
              height: ResponsiveSize(context).screenHeight.toPercent(75),
              width: ResponsiveSize(context).screenWidth,
              child: StreamBuilder(
                stream: viewModel.getStream(),
                builder: (context, snapshot) {
                  //show circular progess bar while waiting for data
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.connectionState == ConnectionState.active) {
                    // If stream is active and data is available
                    if (snapshot.hasData) {
                      List<CurrencyEntity> data = snapshot.data;

                      return ListView.builder(
                        itemCount: data.length, // Adjust based on data
                        itemBuilder: (context, index) {
                          CurrencyWidgetEntity currency =
                              CurrencyWidgetEntity.fromCurrency(data[index]);
                          return CurrencyCardWidget(currency: currency);
                        },
                      );
                    } else {
                      // No data available yet, but stream is active
                      return loadingTextWidget();
                    }
                  }
                  //default state
                  return loadingTextWidget();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center loadingTextWidget() => Center(child: Text(LocaleKeys.home_wait.tr()));
}


/*
TODO: We will inspect here before remove so it should be stay here :)
-------------------
  if (snapshot.connectionState == ConnectionState.done) {
    // If the stream is done and no data was received
    if (snapshot.hasData) {
      var data = snapshot.data;
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          var item = data[index];
          return Text("Currency: ${item}");
        },
      );
    } else {
      return Center(child: Text('No Data Available'));
    }
  }
-------------------
*/
import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/widgets/currency_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class CurrencyCardListWidget extends ConsumerWidget {
  const CurrencyCardListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider.notifier);
    final appGlobal = ref.watch(appGlobalProvider.notifier);

    return SizedBox(
      height: ResponsiveSize(context).screenHeight.toPercent(50),
      width: ResponsiveSize(context).screenWidth,
      child: StreamBuilder2(
        streams: StreamTuple2(
            appGlobal.getDataStream ?? viewModel.getEmptyStream,
            viewModel.searchBarStreamController ?? viewModel.getEmptyStream),
        initialData: InitialDataTuple2(null, null),
        builder: (context, snapshots) {
          // Stream henüz aktif değilse veya veriler yoksa, loading widget'ı göster
          if (snapshots.snapshot1.connectionState != ConnectionState.active) {
            return loadingIndicatorWidget();
          }

          if (!snapshots.snapshot1.hasData ||
              snapshots.snapshot1.data?.length == null ||
              snapshots.snapshot1.data?[0] == null) {
            return loadingTextWidget();
          }

          List<CurrencyEntity>? data = snapshots.snapshot1.data;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            //the reason why we dont give param as data instead of snapshots.snapshot1.data is that
            //you can not call providers during build
            //so we calculate profit after widget build
            //and our data is changing below with our filter chars.
            //so we need to calculate profit after data is filtered
            //if we directly use calculateProfitBalance(data) it will fetch filtered data by keyboard and miscalculate profit.
            viewModel.calculateProfitBalance(ref);
          });

          data = viewModel.filterCurrencyData(
              data, snapshots.snapshot2.data ?? DefaultLocalStrings.emptyText);
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
    );
  }
}

Center loadingTextWidget() => Center(child: Text(LocaleKeys.home_wait.tr()));
Center loadingIndicatorWidget() =>
    const Center(child: CircularProgressIndicator());

import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/widgets/currency_card_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/loading_skeletonizer_widget.dart';
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

    // Stream sadece bir yerde dinleniyor
    final dataStream = appGlobal.getDataStream ?? viewModel.getEmptyStream;
    final searchStream =
        viewModel.searchBarStreamController ?? viewModel.getEmptyStream;

    return SizedBox(
      height: ResponsiveSize(context).screenHeight.toPercent(50),
      width: ResponsiveSize(context).screenWidth,
      child: StreamBuilder2(
        streams: StreamTuple2(dataStream, searchStream),
        initialData: InitialDataTuple2(null, null),
        builder: (context, snapshots) {
          
          // Burası incelenecek şimdilik yorum satırına alındı 
          // TODO:
          // if (snapshots.snapshot1.connectionState == ConnectionState.waiting) {
          //   return Text("Connecting"); //loadingIndicatorWidget();
          // }

          if (!snapshots.snapshot1.hasData ||
              snapshots.snapshot1.data?.length == null) {
            return const LoadingSkeletonizerWidget();
          }

          List<CurrencyEntity>? data = snapshots.snapshot1.data;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Verilerin filtresini uyguladıktan sonra kazancı hesaplayın
            viewModel.calculateProfitBalance(ref);
          });

          // Search bar'dan gelen veriyi filtrele
          data = viewModel.filterCurrencyData(
              data, snapshots.snapshot2.data ?? DefaultLocalStrings.emptyText);

          // Güncellenmiş verilerle listeyi render et
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

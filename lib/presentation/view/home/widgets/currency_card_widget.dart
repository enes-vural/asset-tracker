import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/mixins/get_currency_icon_mixin.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/widgets/loading_skeletonizer_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

enum SortType { name, buy, sell, change }

enum SortOrder { ascending, descending }

class CurrencyListWidget extends ConsumerStatefulWidget {
  const CurrencyListWidget({super.key});

  @override
  ConsumerState<CurrencyListWidget> createState() => _CurrencyListWidgetState();
}

class _CurrencyListWidgetState extends ConsumerState<CurrencyListWidget>
    with GetCurrencyIconMixin {
  SortType currentSortType = SortType.name;
  SortOrder currentSortOrder = SortOrder.ascending;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeViewModelProvider.notifier);
    final appGlobal = ref.watch(appGlobalProvider.notifier);

    final dataStream = appGlobal.getDataStream ?? viewModel.getEmptyStream;
    final searchStream =
        viewModel.searchBarStreamController ?? viewModel.getEmptyStream;

    return Container(
      height: ResponsiveSize(context)
          .screenHeight
          .toPercent(85), // Yüksekliği artırdık
      width: ResponsiveSize(context).screenWidth,
      decoration: BoxDecoration(
        color: DefaultColorPalette.vanillaWhite,
        borderRadius: BorderRadius.circular(AppSize.mediumRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          _buildSortableHeader(),
          // Divider
          Container(
            height: 1,
            color: DefaultColorPalette.grey300,
          ),
          // List
          Expanded(
            child: StreamBuilder2(
              streams: StreamTuple2(dataStream, searchStream),
              initialData: InitialDataTuple2(null, null),
              builder: (context, snapshots) {
                if (!snapshots.snapshot1.hasData ||
                    snapshots.snapshot1.data?.length == null) {
                  return const LoadingSkeletonizerWidget();
                }

                List<CurrencyEntity>? data = snapshots.snapshot1.data;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  viewModel.calculateProfitBalance(ref);
                });

                data = viewModel.filterCurrencyData(data,
                    snapshots.snapshot2.data ?? DefaultLocalStrings.emptyText);

                // Sıralama uygula
                data = _sortCurrencyData(data ?? []);

                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: data.length,
                  separatorBuilder: (context, index) => Container(
                    height: 1,
                    color: DefaultColorPalette.grey100,
                  ),
                  itemBuilder: (context, index) {
                    CurrencyWidgetEntity currency =
                        CurrencyWidgetEntity.fromCurrency(data![index]);
                    return _buildCurrencyRow(context, currency, viewModel);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.mediumPadd, vertical: AppSize.smallPadd),
      child: Row(
        children: [
          // Currency & Icon
          Expanded(
            flex: 3,
            child: _buildSortableHeaderItem(
              title: "Currency",
              sortType: SortType.name,
            ),
          ),
          // Buy Price
          Expanded(
            flex: 2,
            child: _buildSortableHeaderItem(
              title: "Alış",
              sortType: SortType.buy,
              textAlign: TextAlign.center,
            ),
          ),
          // Sell Price
          Expanded(
            flex: 2,
            child: _buildSortableHeaderItem(
              title: "Satış",
              sortType: SortType.sell,
              textAlign: TextAlign.center,
            ),
          ),
          // Change %
          Expanded(
            flex: 2,
            child: _buildSortableHeaderItem(
              title: "Değişim",
              sortType: SortType.change,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortableHeaderItem({
    required String title,
    required SortType sortType,
    TextAlign textAlign = TextAlign.start,
  }) {
    bool isActive = currentSortType == sortType;

    return InkWell(
      onTap: () {
        setState(() {
          if (currentSortType == sortType) {
            // Aynı sütuna tekrar tıklandıysa sıralama yönünü değiştir
            currentSortOrder = currentSortOrder == SortOrder.ascending
                ? SortOrder.descending
                : SortOrder.ascending;
          } else {
            // Farklı sütuna tıklandıysa yeni sütunu seç ve ascending yap
            currentSortType = sortType;
            currentSortOrder = SortOrder.ascending;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSize.smallPadd),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: textAlign == TextAlign.center
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: isActive
                  ? CustomTextStyle.blackColorBoldPoppins(AppSize.smallText)
                  : CustomTextStyle.greyColorPoppins(AppSize.smallText),
              textAlign: textAlign,
            ),
            if (isActive) ...[
              const SizedBox(width: 4),
              Icon(
                currentSortOrder == SortOrder.ascending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                size: 12,
                //Default
                color: Colors.pink,
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<CurrencyEntity> _sortCurrencyData(List<CurrencyEntity> data) {
    List<CurrencyEntity> sortedData = List.from(data);

    sortedData.sort((a, b) {
      int comparison = 0;

      switch (currentSortType) {
        case SortType.name:
          comparison = (a.code).compareTo(b.code);
          break;
        case SortType.buy:
          double aValue = double.tryParse(a.alis.toString()) ?? 0.0;
          double bValue = double.tryParse(b.alis.toString()) ?? 0.0;
          comparison = aValue.compareTo(bValue);
          break;
        case SortType.sell:
          double aValue = double.tryParse(a.satis.toString()) ?? 0.0;
          double bValue = double.tryParse(b.satis.toString()) ?? 0.0;
          comparison = aValue.compareTo(bValue);
          break;
        case SortType.change:
          double aValue = double.tryParse(a.kapanis.toString()) ?? 0.0;
          double bValue = double.tryParse(b.kapanis.toString()) ?? 0.0;
          comparison = aValue.compareTo(bValue);
          break;
      }

      return currentSortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    return sortedData;
  }

  Widget _buildCurrencyRow(
      BuildContext context, CurrencyWidgetEntity currency, dynamic viewModel) {
    return InkWell(
      onTap: () {
        viewModel.routeTradePage(context, currency.entity);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppSize.mediumPadd, vertical: AppSize.smallPadd + 2),
        child: Row(
          children: [
            // Currency Info & Icon
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: AppSize.mediumRadius,
                    backgroundColor: DefaultColorPalette.grey100,
                    child: Image.asset(
                      getCurrencyIcon(currency.name),
                      width: AppSize.largeIcon,
                      height: AppSize.largeIcon,
                      fit: BoxFit.cover,
                    ),
                  ),
                  CustomSizedBox.smallWidth(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currency.name.toString(),
                          style: CustomTextStyle.blackColorBoldPoppins(
                              AppSize.smallText2),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          currency.code.toString(),
                          style: CustomTextStyle.greyColorPoppins(
                              AppSize.small2Text),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Buy Price
            Expanded(
              flex: 2,
              child: Text(
                currency.alis.toString(),
                style: CustomTextStyle.blackColorBoldPoppins(AppSize.smallText),
                textAlign: TextAlign.center,
              ),
            ),
            // Sell Price
            Expanded(
              flex: 2,
              child: Text(
                currency.satis.toString(),
                style: CustomTextStyle.blackColorBoldPoppins(AppSize.smallText),
                textAlign: TextAlign.center,
              ),
            ),
            // Change Percentage
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.smallPadd,
                  vertical: AppSize.smallPadd,
                ),
                decoration: BoxDecoration(
                  color:
                      _getChangeColor(currency.entity.kapanis).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSize.smallRadius),
                ),
                child: Text(
                  "%${currency.entity.kapanis.toString()}",
                  style: CustomTextStyle.blackColorBoldPoppins(
                    //_getChangeColor(currency.entity.kapanis),
                    AppSize.small2Text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getChangeColor(dynamic changeValue) {
    if (changeValue == null) return DefaultColorPalette.grey400;

    double value = 0.0;
    if (changeValue is String) {
      value = double.tryParse(changeValue) ?? 0.0;
    } else if (changeValue is num) {
      value = changeValue.toDouble();
    }

    if (value > 0) {
      return DefaultColorPalette.vanillaGreen;
    } else if (value < 0) {
      return DefaultColorPalette.errorRed;
    } else {
      return DefaultColorPalette.grey400;
    }
  }
}

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
    final viewModel = ref.watch(homeViewModelProvider);
    final appGlobal = ref.watch(appGlobalProvider);

    // Global assets'i direkt AppGlobalProvider'dan al
    List<CurrencyEntity>? globalAssets = appGlobal.globalAssets;

    // Search stream'i hala kullanabilirsiniz çünkü o sadece arama için
    final searchStream = viewModel.searchBarStreamController;

    return Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildSortableHeader(),
          // Divider
          Container(
            height: 1,
            color: DefaultColorPalette.grey300,
          ),
          // List - StreamBuilder yerine direkt build
          _buildCurrencyList(globalAssets, searchStream, viewModel),
        ],
      ),
    );
  }

  Widget _buildCurrencyList(
    List<CurrencyEntity>? globalAssets,
    Stream? searchStream,
    dynamic viewModel,
  ) {
    // Global assets null veya boşsa loading göster
    if (globalAssets == null || globalAssets.isEmpty) {
      return const LoadingSkeletonizerWidget();
    }

    // Search stream varsa onu dinle, yoksa boş string kullan
    return StreamBuilder<String>(
      stream: searchStream?.cast<String>(),
      initialData: DefaultLocalStrings.emptyText,
      builder: (context, searchSnapshot) {
        String searchQuery =
            searchSnapshot.data ?? DefaultLocalStrings.emptyText;

        // Post frame callback'i daha güvenli hale getirelim
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            viewModel.calculateProfitBalance(ref);
          }
        });

        // Filter data
        List<CurrencyEntity>? filteredData = viewModel.filterCurrencyData(
          globalAssets,
          searchQuery,
        );

        // Sıralama uygula
        filteredData = _sortCurrencyData(filteredData ?? []);

        // Filtered data boşsa mesaj göster
        if (filteredData.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(AppSize.mediumPadd),
            child: Center(
              child: Text(
                searchQuery.isNotEmpty
                    ? "Arama sonucu bulunamadı"
                    : "Hiç para birimi bulunamadı",
                style: TextStyle(
                  color: DefaultColorPalette.grey400,
                  fontSize: AppSize.mediumText,
                ),
              ),
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(filteredData.length, (index) {
            CurrencyWidgetEntity currency =
                CurrencyWidgetEntity.fromCurrency(filteredData![index]);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCurrencyRow(context, currency, viewModel),
                if (index < filteredData.length - 1)
                  Container(
                    height: 1,
                    color: DefaultColorPalette.grey100,
                  ),
              ],
            );
          }),
        );
      },
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
              title: "Birim",
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
            currentSortOrder = currentSortOrder == SortOrder.ascending
                ? SortOrder.descending
                : SortOrder.ascending;
          } else {
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
        padding: const EdgeInsets.symmetric(
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
                  const CustomSizedBox.smallWidth(),
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
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.smallPadd,
                  vertical: AppSize.smallPadd,
                ),
                decoration: BoxDecoration(
                  color: _getChangeColor(currency.entity.dir.alisDir)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSize.smallRadius),
                ),
                child: Text(
                  currency.alis.toString(),
                  style: CustomTextStyle.blackColorBoldPoppins(
                    AppSize.small2Text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const CustomSizedBox.smallWidth(),
            // Sell Price
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.smallPadd,
                  vertical: AppSize.smallPadd,
                ),
                decoration: BoxDecoration(
                  color: _getChangeColor(currency.entity.dir.satisDir)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSize.smallRadius),
                ),
                child: Text(
                  currency.satis.toString(),
                  style: CustomTextStyle.blackColorBoldPoppins(
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

    if (changeValue is! String) {
      return DefaultColorPalette.grey400;
    }

    if (changeValue.isEmpty) {
      return DefaultColorPalette.grey400;
    }

    if (changeValue == "up" || ((double.tryParse(changeValue) ?? 0.0) > 0)) {
      return DefaultColorPalette.vanillaGreen;
    } else if (changeValue == "down" ||
        ((double.tryParse(changeValue) ?? 0.0) < 0)) {
      return DefaultColorPalette.errorRed;
    }
    return DefaultColorPalette.grey400;
  }
}

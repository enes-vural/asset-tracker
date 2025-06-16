import 'dart:async';

import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/constants/enums/widgets/currency_card_widget_enums.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/mixins/get_currency_icon_mixin.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/widgets/loading_skeletonizer_widget.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SortType {
  name,
  buy,
  sell,
  custom,
}

enum SortOrder { ascending, descending }

class CurrencyListWidget extends ConsumerStatefulWidget {
  const CurrencyListWidget({super.key});

  @override
  ConsumerState<CurrencyListWidget> createState() => _CurrencyListWidgetState();
}

class _CurrencyListWidgetState extends ConsumerState<CurrencyListWidget>
    with GetCurrencyIconMixin {
  SortType currentSortType = SortType.custom;
  SortOrder currentSortOrder = SortOrder.ascending;

  // Cache için key
  static const String _customOrderKey = 'currency_custom_order';
  static const String _sortTypeKey = 'currency_sort_type';

  // Kullanıcı özel sıralaması
  List<String> _customOrder = [];
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _loadCustomOrder();
  }

  // Özel sıralamayı kaydet
  Future<void> _saveCustomOrder(List<String> order) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_customOrderKey, order);
    await prefs.setString(_sortTypeKey, 'custom');

    setState(() {
      _customOrder = order;
      currentSortType = SortType.custom;
    });
  }

  Future<void> _loadCustomOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final customOrderJson = prefs.getStringList(_customOrderKey) ?? [];

    setState(() {
      _customOrder = customOrderJson;
      // Başlangıçta her zaman custom order
      //TODO: Gereksiz kod.
      currentSortType = SortType.custom;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeViewModelProvider);
    final appGlobal = ref.watch(appGlobalProvider);

    List<CurrencyEntity>? globalAssets = appGlobal.globalAssets;
    final searchStream = viewModel.searchBarStreamController;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: ResponsiveSize(context).screenWidth,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(AppSize.mediumRadius),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ],
        border: isDark
            ? null
            : Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
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
          // List
          _buildCurrencyList(globalAssets, searchStream, viewModel),
        ],
      ),
    );
  }

  Widget _buildCurrencyList(
    List<CurrencyEntity>? globalAssets,
    Stream? searchStream,
    HomeViewModel viewModel,
  ) {
    if (globalAssets == null || globalAssets.isEmpty) {
      return const LoadingSkeletonizerWidget();
    }

    return StreamBuilder<String>(
      stream: searchStream?.cast<String>(),
      initialData: DefaultLocalStrings.emptyText,
      builder: (context, searchSnapshot) {
        String searchQuery =
            searchSnapshot.data ?? DefaultLocalStrings.emptyText;

        List<CurrencyEntity>? filteredData = viewModel.filterCurrencyData(
          globalAssets,
          searchQuery,
        );

        // Sıralama uygula
        filteredData = _sortCurrencyData(filteredData ?? []);

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

        // Eğer custom order modundaysa ReorderableListView kullan
        if (currentSortType == SortType.custom &&
            searchQuery.isEmpty &&
            _isEditMode) {
          return _buildReorderableList(filteredData, viewModel);
        } else {
          return _buildNormalList(filteredData, viewModel);
        }
      },
    );
  }

  Widget _buildReorderableList(
      List<CurrencyEntity> data, HomeViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(data.length, (index) {
        CurrencyWidgetEntity currency =
            CurrencyWidgetEntity.fromCurrency(data[index]);

        return LongPressDraggable<int>(
          data: index,
          feedback: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(AppSize.smallRadius),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppSize.smallRadius),
                border: Border.all(color: Colors.pink, width: 2),
              ),
              child: _buildCurrencyRow(context, currency, viewModel,
                  isDragMode: true, isInDrag: true),
            ),
          ),
          childWhenDragging: Container(
            decoration: BoxDecoration(
              color: DefaultColorPalette.grey100.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppSize.smallRadius),
            ),
            child: _buildCurrencyRow(context, currency, viewModel,
                isDragMode: true, isPlaceholder: true),
          ),
          child: DragTarget<int>(
            onAcceptWithDetails: (fromIndex) {
              if (fromIndex.data != index) {
                setState(() {
                  final CurrencyEntity item = data.removeAt(fromIndex.data);
                  data.insert(index, item);

                  // Yeni sıralamayı kaydet
                  List<String> newOrder = data.map((e) => e.code).toList();
                  _saveCustomOrder(newOrder);
                });
              }
            },
            builder: (context, candidateData, rejectedData) {
              bool isAccepting = candidateData.isNotEmpty;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isAccepting
                      ? Colors.pink.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSize.smallRadius),
                  border: isAccepting
                      ? Border.all(color: Colors.pink, width: 2)
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCurrencyRow(context, currency, viewModel,
                        isDragMode: true),
                    if (index < data.length - 1)
                      Container(
                        height: 1,
                        color: DefaultColorPalette.grey100,
                      ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildNormalList(List<CurrencyEntity> data, HomeViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(data.length, (index) {
        CurrencyWidgetEntity currency =
            CurrencyWidgetEntity.fromCurrency(data[index]);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCurrencyRow(context, currency, viewModel),
            if (index < data.length - 1)
              Container(
                height: 1,
                color: DefaultColorPalette.grey100,
              ),
          ],
        );
      }),
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
          IconButton(
            icon: Icon(
              _isEditMode ? Icons.done : Icons.edit,
              color: _isEditMode ? Colors.green : DefaultColorPalette.grey400,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
              });
            },
            tooltip: _isEditMode ? "Düzenlemeyi bitir" : "Sıralamayı düzenle",
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
        if (_isEditMode) {
          return;
        }
        setState(() {
          if (currentSortType == sortType) {
            if (currentSortOrder == SortOrder.ascending) {
              currentSortOrder = SortOrder.descending;
            } else {
              // 3. tıklamada orijinal sıralamaya geç
              currentSortType = SortType.custom;
              currentSortOrder = SortOrder.ascending;
            }
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
                  ? CustomTextStyle.blackColorBoldPoppins(
                      context, AppSize.smallText)
                  : CustomTextStyle.greyColorPoppins(
                      context, AppSize.smallText),
              textAlign: textAlign,
            ),
            if (isActive && currentSortType != SortType.custom) ...[
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

    // Custom order - eğer özel sıralama varsa onu kullan, yoksa normal sıralama
    if (currentSortType == SortType.custom) {
      if (_customOrder.isNotEmpty) {
        // Özel sıralama var, onu uygula
        sortedData.sort((a, b) {
          int aIndex = _customOrder.indexOf(a.code);
          int bIndex = _customOrder.indexOf(b.code);

          // Eğer her ikisi de custom order'da yoksa normal sıralama
          if (aIndex == -1 && bIndex == -1) {
            return a.code.compareTo(b.code);
          }

          // Custom order'da olmayan elemanları sona koy
          if (aIndex == -1) return 1;
          if (bIndex == -1) return -1;

          return aIndex.compareTo(bIndex);
        });
      } else {
        // Özel sıralama yok, normal alfabetik sıralama yap
        sortedData.sort((a, b) => a.code.compareTo(b.code));
      }
      return sortedData;
    }

    // Normal sıralama
    List<CurrencyWidgetEntity> widgetData = [];
    sortedData.forEach((value) {
      widgetData.add(CurrencyWidgetEntity.fromCurrency(value));
    });

    Map<String, CurrencyWidgetEntity> widgetMap = {};
    for (int i = 0; i < sortedData.length; i++) {
      widgetMap[sortedData[i].code] = widgetData[i];
    }

    sortedData.sort((a, b) {
      int comparison = 0;

      switch (currentSortType) {
        case SortType.name:
          String aName = widgetMap[a.code]?.name ?? a.code;
          String bName = widgetMap[b.code]?.name ?? b.code;
          comparison = aName.compareTo(bName);
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
        case SortType.custom:
          // Custom sorting is handled above
          break;
      }

      return currentSortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    return sortedData;
  }

  Widget _buildCurrencyRow(
    BuildContext context,
    CurrencyWidgetEntity currency,
    HomeViewModel viewModel, {
    bool isDragMode = false,
    bool isInDrag = false,
    bool isPlaceholder = false,
  }) {
    return InkWell(
      onTap: isInDrag
          ? null
          : () {
              viewModel.routeTradePage(context, currency.entity);
            },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.mediumPadd, vertical: AppSize.smallPadd + 2),
        child: Row(
          children: [
            // Drag handle (sadece drag modunda göster)
            if (isDragMode) ...[
              Icon(
                Icons.drag_handle,
                color: isPlaceholder
                    ? DefaultColorPalette.grey200
                    : (isInDrag ? Colors.pink : DefaultColorPalette.grey400),
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            // Currency Info & Icon
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: AppSize.mediumRadius,
                    backgroundColor: isPlaceholder
                        ? DefaultColorPalette.grey200
                        : DefaultColorPalette.grey100,
                    child: Opacity(
                      opacity: isPlaceholder ? 0.5 : 1.0,
                      child: Image.asset(
                        getCurrencyIcon(currency.code),
                        width: AppSize.largeIcon,
                        height: AppSize.largeIcon,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  const CustomSizedBox.smallWidth(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Opacity(
                          opacity: isPlaceholder ? 0.5 : 1.0,
                          child: _buildResponsiveCurrencyName(
                              context, currency.name.toString().toUpperCase()),
                        ),
                        Opacity(
                          opacity: isPlaceholder ? 0.5 : 1.0,
                          child: Text(
                            currency.code.toString(),
                            style: CustomTextStyle.greyColorPoppins(
                                context, AppSize.small2Text),
                            overflow: TextOverflow.ellipsis,
                          ),
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
              child: Opacity(
                opacity: isPlaceholder ? 0.5 : 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.smallPadd,
                    vertical: AppSize.smallPadd,
                  ),
                  decoration: BoxDecoration(
                    color: _getChangeColor(currency.entity.dir.alisDir)
                        .withOpacity(isPlaceholder ? 0.05 : 0.1),
                    borderRadius: BorderRadius.circular(AppSize.smallRadius),
                  ),
                  child: Text(
                    currency.alis.toString(),
                    style: CustomTextStyle.blackColorBoldPoppins(
                      context,
                      AppSize.small2Text,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const CustomSizedBox.smallWidth(),
            // Sell Price
            Expanded(
              flex: 2,
              child: Opacity(
                opacity: isPlaceholder ? 0.5 : 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.smallPadd,
                    vertical: AppSize.smallPadd,
                  ),
                  decoration: BoxDecoration(
                    color: _getChangeColor(currency.entity.dir.satisDir)
                        .withOpacity(isPlaceholder ? 0.05 : 0.1),
                    borderRadius: BorderRadius.circular(AppSize.smallRadius),
                  ),
                  child: Text(
                    currency.satis.toString(),
                    style: CustomTextStyle.blackColorBoldPoppins(
                      context,
                      AppSize.small2Text,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveCurrencyName(
      BuildContext context, String currencyName) {
    return Text(
      currencyName,
      style: CustomTextStyle.blackColorBoldPoppins(
          context,
          currencyName.length > 15
              ? AppSize.xSmallText + 2
              : AppSize.smallText),
      overflow: TextOverflow.visible,
      maxLines: 2,
      softWrap: true,
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

    if (changeValue == CurrencyDirectionEnum.UP.value ||
        ((double.tryParse(changeValue) ?? 0.0) > 0)) {
      return DefaultColorPalette.vanillaGreen;
    } else if (changeValue == CurrencyDirectionEnum.DOWN.value ||
        ((double.tryParse(changeValue) ?? 0.0) < 0)) {
      return DefaultColorPalette.errorRed;
    }
    return DefaultColorPalette.grey400;
  }
}

import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PieChartWidget extends ConsumerStatefulWidget {
  const PieChartWidget({super.key});

  @override
  ConsumerState<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends ConsumerState<PieChartWidget> {
  List<PieChartSectionData> _sections = [];
  List<UserCurrencyEntity> prevList = [];

  @override
  Widget build(BuildContext context) {
    List<UserCurrencyEntity>? currencyList;

    currencyList = ref.watch(appGlobalProvider.select(
      (value) => value.getUserData?.currencyList,
    ));

    if (prevList.isEmpty || prevList == []) {
      prevList = currencyList ?? [];
      _sections = _generateSections(currencyList);
    }

    //TODO: Collection package for here
    if (prevList != currencyList) {
      prevList = currencyList ?? [];
      _sections = _generateSections(currencyList);
    }

    return CustomPadding.hugeTop(
      widget: Center(
        child: SizedBox(
          width: 200,
          height: 250,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: AppSize.chartCenterRadius,
              sections: List.of(_sections),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections(List<UserCurrencyEntity>? data) {
    final Map<String, double> currencyTotals = {};
    final List<PieChartSectionData> sections = [];

    data?.forEach((element) {
      final totalValue = element.amount * element.price;
      currencyTotals.update(
        element.currencyCode,
        (value) => value + totalValue,
        ifAbsent: () => totalValue,
      );
    });

    currencyTotals.forEach((currencyCode, totalValue) {
      sections.add(
        PieChartSectionData(
          color: DefaultColorPalette.randomColor(),
          value: totalValue,
          title: currencyCode,
          radius: AppSize.chartRadius,
          titleStyle: const TextStyle(
            color: DefaultColorPalette.vanillaWhite,
            fontSize: AppSize.smallText,
          ),
        ),
      );
    });

    return sections;
  }


}

import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatefulWidget {
  final List<UserCurrencyEntityModel>? dataItems;

  const PieChartWidget({super.key, this.dataItems});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  List<PieChartSectionData> _sections = [];

  @override
  void initState() {
    super.initState();
    _generateSections();
  }

  // Helper function to group and calculate values
  void _generateSections() {
    // Create a map to store total values for each currencyCode
    Map<String, double> currencyTotals = {};

    // Group the data and sum values for each currencyCode
    widget.dataItems?.forEach((element) {
      final totalValue = element.amount * element.price;

      // If the currencyCode already exists, add the value to the existing total
      if (currencyTotals.containsKey(element.currencyCode)) {
        currencyTotals[element.currencyCode] =
            currencyTotals[element.currencyCode]! + totalValue;
      } else {
        currencyTotals[element.currencyCode] = totalValue;
      }
    });

    // Generate PieChartSectionData from the grouped data
    currencyTotals.forEach((currencyCode, totalValue) {
      Color? sectionColor = DefaultColorPalette.randomColor();
      _sections.add(
        PieChartSectionData(
          color: sectionColor,
          value: totalValue,
          title: currencyCode,
          radius: AppSize.chartRadius,
          titleStyle: const TextStyle(
              color: DefaultColorPalette.vanillaWhite,
              fontSize: AppSize.smallText),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPadding.hugeTop(
      widget: Center(
        child: SizedBox(
          width: 200,
          height: 250,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2, // Dilimler arası boşluk
              centerSpaceRadius: AppSize.chartCenterRadius, // Ortadaki boşluk
              sections: _sections,
            ),
          ),
        ),
      ),
    );
  }
}

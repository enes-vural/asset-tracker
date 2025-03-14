import 'package:asset_tracker/core/config/theme/default_theme.dart';
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
    widget.dataItems?.forEach((element) {
      Color? sectionColor = DefaultColorPalette.randomColor();
      _sections.add(
        PieChartSectionData(
          //random color need here for each section
          color: sectionColor,
          value: element.amount * element.price,
          title: element.currencyCode,
          radius: 80,
          titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    });

    super.initState();
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
              centerSpaceRadius: 25, // Ortadaki boşluk
              sections: _sections,
            ),
          ),
        ),
      ),
    );
  }
}

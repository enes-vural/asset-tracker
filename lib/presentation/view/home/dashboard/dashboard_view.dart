import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/usar_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/widgets/currency_card_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  @override
  Widget build(BuildContext context) {
    UserDataEntity? entity = ref.read(appGlobalProvider.notifier).getUserData;
    List<UserCurrencyEntityModel>? list = entity?.currencyList;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          centerTitle: true,
          title: const Text("Dashboard"),
          actions: const [
            CustomPadding.largeHorizontal(
              widget: Icon(Icons.filter_alt_off_outlined),
            ),
          ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PieChartWidget(
            dataItems: list,
          ),
          Text(
            "Available Balance",
            style: TextStyle(color: DefaultColorPalette.grey500, fontSize: 15),
          ),
          const Text(
            "₺102.258,25",
            style: TextStyle(
                color: DefaultColorPalette.vanillaBlack, fontSize: 24),
          ),
          const CustomSizedBox.mediumGap(),
          Divider(color: Colors.grey.shade200),
          const CustomSizedBox.hugeGap(),
          ListView.builder(
            itemBuilder: (context, index) {
              return CustomPadding.hugeHorizontal(
                widget: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey.shade300,
                      ),
                      const CustomSizedBox.largeWidth(),
                      Text(list?[index].currencyCode ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            color: Colors.grey.shade800,
                            fontSize: 16,
                          )),
                      const Expanded(child: CustomSizedBox.empty()),
                      Text(
                          "- ₺ ${(list?[index].price ?? 0.0) * (list?[index].amount ?? 0.00)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w100,
                            color: Colors.black,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
              );
            },
            itemCount: list?.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          )
        ],
      ),
    );
  }
}

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

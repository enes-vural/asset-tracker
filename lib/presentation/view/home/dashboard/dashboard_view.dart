import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/usar_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/home/widgets/balance_text_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/custom_pie_chart_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/transaction/users_asset_transaction_widget.dart';
import 'package:asset_tracker/provider/app_global_provider.dart';
import 'package:auto_route/auto_route.dart';
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
    final AppGlobalProvider appGlobal = ref.watch(appGlobalProvider);

    UserDataEntity? entity = appGlobal.getUserData;
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: ResponsiveSize(context).screenHeight.toPercent(45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PieChartWidget(dataItems: list),
                  Text(
                    "Available Balance",
                    style: TextStyle(
                        color: DefaultColorPalette.grey500, fontSize: 15),
                  ),
                  const BalanceTextWidget(),
                ],
              ),
            ),
            const UserAssetTransactionWidget(),

          ],
        ),
      ),
    );
  }

  Container aaa() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.red,
    );
  }
}


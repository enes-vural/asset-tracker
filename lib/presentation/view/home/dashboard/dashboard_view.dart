import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/widgets/custom_icon.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/usar_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/home/widgets/balance_text_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/custom_pie_chart_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/transaction/users_asset_transaction_widget.dart';
import 'package:asset_tracker/provider/app_global_provider.dart';

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
      appBar: _appBarWidget(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          child: Column(
            children: [
              PieChartWidget(dataItems: list),
              availableTextWidget(),
              const BalanceTextWidget(),
              const CustomSizedBox.hugeGap(),
              const SizedBox(child: UserAssetTransactionWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Text availableTextWidget() {
    return Text(
      LocaleKeys.dashboard_availableBalance.tr(),
      style: TextStyle(
        color: DefaultColorPalette.grey500,
        fontSize: AppSize.mediumText,
      ),
    );
  }

  AppBar _appBarWidget() {
    return AppBar(
        backgroundColor: DefaultColorPalette.grey100,
        centerTitle: true,
        title: Text(LocaleKeys.dashboard_dashboard.tr()),
        actions: const [
          CustomPadding.largeHorizontal(
            widget: CustomIcon.filterIcon(),
          ),
        ]);
  }
}

import 'package:asset_tracker/core/helpers/dialog_helper.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/home/widgets/unauthorized_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/presentation/view/home/widgets/balance_text_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/custom_pie_chart_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/transaction/users_asset_transaction_widget.dart';

@RoutePage()
class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(dashboardViewModelProvider);
    final authState = ref.watch(authGlobalProvider);

    EasyDialog.showDialogOnProcess(context, ref, dashboardViewModelProvider);
    return PopScope(
      canPop: viewModel.canPop,
      child: authState.getCurrentUser?.user != null
          ? _oldScaffold()
          : const UnAuthorizedWidget(page: UnAuthorizedPage.WALLET),
    );
  }

  Scaffold _oldScaffold() {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          child: Column(
            children: [
              const PieChartWidget(),
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
}

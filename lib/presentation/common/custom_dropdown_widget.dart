import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/widgets/custom_icon.dart';
import 'package:asset_tracker/presentation/view_model/home/trade/trade_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropDownWidget<T> extends StatelessWidget {
  const CustomDropDownWidget({
    super.key,
    required this.pageCurrency,
    required this.viewModel,
    required this.ref,
  });

  final String? pageCurrency;
  final TradeViewModel viewModel;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      borderRadius: BorderRadius.circular(AppSize.mediumRadius),
      icon: const CustomIcon.dollarIcon(),
      hint: customDropDownHintTextWidget(),
      //TODO: research the focus node
      dropdownColor: DefaultColorPalette.vanillaWhite,
      items: getCurrencyListAsDMenuItem(),
      onChanged: (String? newValue) {
        viewModel.changeSelectedCurrency(newValue);
      },
      value: viewModel.selectedCurrency,
    );
  }

  List<DropdownMenuItem<String>> getCurrencyListAsDMenuItem() {
    return viewModel
        .getCurrencyList(ref)
        .map((e) => DropdownMenuItem(
              value: e.code,
              child: Text(e.code),
            ))
        .toList();
  }

  Text customDropDownHintTextWidget() {
    return Text(
        pageCurrency != null && pageCurrency == DefaultLocalStrings.emptyText
            ? LocaleKeys.trade_selectCurrecy.tr()
            : pageCurrency.toString());
  }
}

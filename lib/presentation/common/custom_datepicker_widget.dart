import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/widgets/custom_icon.dart';
import 'package:asset_tracker/presentation/view_model/home/trade/trade_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomDatePickerWidget extends StatelessWidget {
  const CustomDatePickerWidget({
    super.key,
    required this.viewModel,
  });

  //şu anda default olarak TradeViewModel alıyor.
  //Başka sayfalarda kullanılacağı zaman bu iki viewModeli
  //sarmalayan bir baseViewModelden türetilen bir T type ı ile
  //kullanılabilir.
  //ama şimdilik böyle bırakıyorum.

  final TradeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          initialDate: viewModel.selectedDate,
          confirmText: LocaleKeys.trade_buy.tr(),
          cancelText: LocaleKeys.trade_cancel.tr(),
        ).then((DateTime? newDate) {
          viewModel.changeSelectedDate(newDate);
        });
      },
      child: const CustomIcon.defaultCalendar(),
    );
  }
}

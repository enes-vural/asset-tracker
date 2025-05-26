import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/helpers/dialog_helper.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/common/custom_datepicker_widget.dart';
import 'package:asset_tracker/presentation/common/custom_dropdown_widget.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_form_widget.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_submit_widget.dart';
import 'package:asset_tracker/presentation/view_model/home/trade/trade_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TradeView extends ConsumerStatefulWidget {
  final String currecyCode;
  const TradeView(
      {super.key, @PathParam('currency') required this.currecyCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TradeViewState();
}

class _TradeViewState extends ConsumerState<TradeView> with ValidatorMixin {
  @override
  void initState() {
    super.initState();
    //if user open this page by clicking a currency card in home view
    //we automatically set the selected currency to that currency
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(tradeViewModelProvider).getCurrencyList(ref);
      ref
          .read(tradeViewModelProvider)
          .changeSelectedCurrency(widget.currecyCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> tradeFormKey = GlobalKey<FormState>();
    final viewModel = ref.watch(tradeViewModelProvider);

    EasyDialog.showDialogOnProcess(context, ref, tradeViewModelProvider);

    return PopScope(
      canPop: viewModel.canPop,
      child: Scaffold(
        backgroundColor: DefaultColorPalette.vanillaWhite,
        appBar: AppBar(
          backgroundColor: DefaultColorPalette.vanillaWhite,
        ),
        body: Form(
          key: tradeFormKey,
          child: CustomPadding.hugeHorizontal(
            widget: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const CustomSizedBox.largeGap(),
                  AuthFormWidget(
                    label: "Amount",
                    isObs: false,
                    formController: viewModel.amountController,
                    validaor: (value) => checkAmount(value, false),
                    hasLabel: false,
                    hasTitle: true,
                  ),
                  AuthFormWidget(
                    label: "Price per Unit",
                    isObs: false,
                    formController: viewModel.priceUnitController,
                    onChanged: (value) {
                      print(value);
                      double amount =
                          double.tryParse(viewModel.amountController.text) ??
                              0.0;
                      double pricePerUnit = double.tryParse(value) ?? 0.0;
                      double totalPrice = amount * pricePerUnit;
                      viewModel.priceTotalController.text =
                          totalPrice.toStringAsFixed(2);
                    },
                    validaor: (value) => checkAmount(value, true),
                    hasLabel: false,
                    hasTitle: true,
                  ),
                  AuthFormWidget(
                    label: "Price Total",
                    isObs: false,
                    formController: viewModel.priceTotalController,
                    validaor: (value) => checkAmount(value, true),
                    onChanged: (value) {
                      print(value);
                      double priceTotal = double.tryParse(value) ?? 0.0;
                      double amount =
                          double.tryParse(viewModel.amountController.text) ??
                              0.0;
                      double pricePerUnit = priceTotal / amount;
                      viewModel.priceUnitController.text =
                          pricePerUnit.toStringAsFixed(2);
                    },
                    hasLabel: false,
                    hasTitle: true,
                  ),
                  customDatePickerWidget(viewModel),

                  CustomDropDownWidget(
                      pageCurrency: widget.currecyCode,
                      viewModel: viewModel,
                      ref: ref),
                  const CustomSizedBox.largeGap(),
                  AuthSubmitWidget(
                      label: "Buy",
                      voidCallBack: () async {
                        if (!tradeFormKey.currentState!.validate()) {
                          EasySnackBar.show(
                              context, LocaleKeys.trade_fillAllFields.tr());
                          return;
                        }
                        viewModel.buyCurrency(ref: ref, context: context);
                      }),
                  // CustomFormField.countForm(
                  //   label: LocaleKeys.trade_buyAmount.tr(),
                  //   controller: viewModel.amountController,
                  //   validator: (value) => checkAmount(value, false),
                  //   type: TextInputType.text,
                  //   icon: Icons.numbers,
                  // ),
                  // const CustomSizedBox.smallGap(),
                  // CustomFormField.countForm(
                  //   label: LocaleKeys.trade_buyPrice.tr(),
                  //   controller: viewModel.priceController,
                  //   validator: (value) => checkAmount(value, true),
                  //   type: TextInputType.text,
                  //   icon: Icons.attach_money_rounded,
                  // ),
                  //   const CustomSizedBox.smallGap(),
                  //   CustomAlign.centerRight(
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         dropDownWidget(viewModel),
                  //         customDatePickerWidget(viewModel),
                  //       ],
                  //     ),
                  //   ),
                  //   buyCurrencyWidget(viewModel, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CustomDatePickerWidget customDatePickerWidget(TradeViewModel viewModel) =>
      CustomDatePickerWidget(
        viewModel: viewModel,
        validator: checkDateTime,
      );

  CustomDropDownWidget<dynamic> dropDownWidget(TradeViewModel viewModel) {
    return CustomDropDownWidget(
      pageCurrency: widget.currecyCode,
      viewModel: viewModel,
      ref: ref,
    );
  }

  ElevatedButton buyCurrencyWidget(
      TradeViewModel viewModel, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await viewModel.buyCurrency(ref: ref, context: context);
        //Firestore business we will add here
      },
      child: Text(LocaleKeys.trade_buy.tr()),
    );
  }

  Text dropdownHintTextWidget() {
    return Text(widget.currecyCode == DefaultLocalStrings.emptyText
        ? LocaleKeys.trade_selectCurrecy.tr()
        : widget.currecyCode);
  }
}

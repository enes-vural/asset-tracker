import 'package:asset_tracker/core/config/constants/global/key/fom_keys.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/core/widgets/custom_align.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/common/custom_form_field.dart';
import 'package:auto_route/annotations.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(tradeViewModelProvider);
    return Scaffold(
      backgroundColor: DefaultColorPalette.grey100,
      appBar: AppBar(
        title: Text(widget.currecyCode),
      ),
      body: Form(
        key: GlobalFormKeys.tradeFormKey,
        autovalidateMode: AutovalidateMode.always,
        child: CustomPadding.hugeHorizontal(
          widget: Column(
            children: [
              const CustomSizedBox.largeGap(),
              CustomFormField.countForm(
                label: 'Buy amount',
                controller: viewModel.amountController,
                validator: checkAmount,
                type: TextInputType.number,
                icon: Icons.numbers,
              ),
              const CustomSizedBox.smallGap(),
              CustomFormField.countForm(
                label: 'Buy price per one',
                controller: viewModel.priceController,
                validator: checkAmount,
                type: TextInputType.number,
                icon: Icons.attach_money_rounded,
              ),
              const CustomSizedBox.smallGap(),
              CustomAlign.centerRight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                      borderRadius: BorderRadius.circular(10),
                      icon: const Icon(
                        Icons.attach_money,
                        color: DefaultColorPalette.vanillaGreen,
                      ),
                      hint: dropdownHintTextWidget(),
                      //Focus Node
                      dropdownColor: Colors.white,
                      items: viewModel
                          .getCurrencyList(ref)
                          .map((e) => DropdownMenuItem(
                                value: e.code,
                                child: Text(e.code),
                              ))
                          .toList(),
                      onChanged: (String? newValue) {
                        viewModel.changeSelectedCurrency(newValue);
                      },
                      value: viewModel.selectedCurrency,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          initialDate: viewModel.selectedDate,
                          confirmText: "Done",
                          cancelText: "Cancel",
                        ).then((DateTime? newDate) {
                          viewModel.changeSelectedDate(newDate);
                        });
                      },
                      child: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await viewModel.buyCurrency(ref: ref, context: context);
                  //Firestore business we will add here
                },
                child: const Text("BUY"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text dropdownHintTextWidget() {
    return Text(
        widget.currecyCode == "" ? "Select Currency" : widget.currecyCode);
  }
}

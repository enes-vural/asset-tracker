import 'package:asset_tracker/core/config/constants/global/key/fom_keys.dart';
import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/core/widgets/custom_align.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_widget_entity.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/common/custom_form_field.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_form_widget.dart';
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
  Widget build(BuildContext context) {
    final viewModel = ref.read(tradeViewModelProvider);
    return Scaffold(
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
              CustomFormField(
                label: 'Amount',
                isObs: false,
                formController: viewModel.amountController,
                validaor: checkAmount,
                type: TextInputType.number,
              ),
              const CustomSizedBox.smallGap(),
              CustomFormField.countForm(
                label: 'Buy Price',
                controller: viewModel.priceController,
                validator: checkAmount,
                type: TextInputType.number,
              ),
              const CustomSizedBox.smallGap(),
              CustomAlign.centerRight(
                child: ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now());
                  },
                  child: const Icon(Icons.calendar_today),
                ),
              ),
              ElevatedButton(
                onPressed: () {
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
}

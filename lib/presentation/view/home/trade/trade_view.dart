import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
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
import 'package:asset_tracker/presentation/view/home/widgets/unauthorized_widget.dart';
import 'package:asset_tracker/presentation/view_model/home/trade/trade_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TradeView extends ConsumerStatefulWidget {
  final String currencyCode;
  final String? price;
  const TradeView({
    super.key,
    @PathParam('currency') required this.currencyCode,
    @PathParam('price') required this.price,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TradeViewState();
}

class _TradeViewState extends ConsumerState<TradeView> with ValidatorMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(tradeViewModelProvider).getCurrencyList(ref);
      // Sadece currency code boş değilse set et
      if (widget.currencyCode.isNotEmpty &&
          widget.currencyCode != DefaultLocalStrings.emptyText) {
        ref
            .read(tradeViewModelProvider)
            .changeSelectedCurrency(widget.currencyCode);
      }
      ref.read(tradeViewModelProvider).getPriceSelectedCurrency(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> tradeFormKey = GlobalKey<FormState>();
    final viewModel = ref.watch(tradeViewModelProvider);
    final authState = ref.watch(authGlobalProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    EasyDialog.showDialogOnProcess(context, ref, tradeViewModelProvider);

    return PopScope(
      canPop: viewModel.canPop,
      child: authState.getCurrentUser?.user != null
          ? _buildTradeView(tradeFormKey, viewModel, context, isDark)
          : const UnAuthorizedWidget(page: UnAuthorizedPage.TRADE),
    );
  }

  Widget _buildTradeView(GlobalKey<FormState> tradeFormKey,
      TradeViewModel viewModel, BuildContext context, bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey[50],
      body: Form(
        key: tradeFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTradeForm(viewModel, isDark),
              const SizedBox(height: 24),
              _buildBuyButton(tradeFormKey, viewModel, context, isDark),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradeForm(TradeViewModel viewModel, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'İşlem Detayları',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Token Seçimi
          CustomDropDownWidget(
            pageCurrency: widget.currencyCode,
            viewModel: viewModel,
            onSelectedChanged: () {
              viewModel.getPriceSelectedCurrency(ref);
            },
          ),

          const SizedBox(height: 16),

          // Miktar
          AuthFormWidget(
            label: "Miktar",
            isObs: false,
            formController: viewModel.amountController,
            validaor: (value) => checkAmount(value, false),
            hasLabel: true,
            hasTitle: false,
            onChanged: (value) {
              double amount = double.tryParse(value) ?? 0.0;
              if (double.tryParse(viewModel.priceUnitController.text) != null) {
                double priceUnit =
                    double.tryParse(viewModel.priceUnitController.text) ?? 0.0;
                if (priceUnit == 0.0) return;
                double priceTotal = amount * priceUnit;
                viewModel.priceTotalController.text =
                    priceTotal.toStringAsFixed(2);
              }
            },
          ),
          
          const SizedBox(height: 16),

          // Adet Fiyatı
          AuthFormWidget(
            label: "Adet Fiyatı (USD)",
            isObs: false,
            formController: viewModel.priceUnitController,
            onChanged: (value) {
              double amount =
                  double.tryParse(viewModel.amountController.text) ?? 0.0;
              double pricePerUnit = double.tryParse(value) ?? 0.0;
              double totalPrice = amount * pricePerUnit;
              if (viewModel.priceTotalController.text !=
                  totalPrice.toStringAsFixed(2)) {
                viewModel.priceTotalController.text =
                    totalPrice.toStringAsFixed(2);
              }
            },
            validaor: (value) => null,
            hasLabel: true,
            hasTitle: false,
          ),

          const SizedBox(height: 16),

          // Toplam Fiyat
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toplam Fiyat',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 4),
                AuthFormWidget(
                  label: "Toplam Fiyat (USD)",
                  isObs: false,
                  formController: viewModel.priceTotalController,
                  validaor: (value) => checkAmount(value, true),
                  onChanged: (value) {
                    double priceTotal = double.tryParse(value) ?? 0.0;
                    double amount =
                        double.tryParse(viewModel.amountController.text) ?? 0.0;
                    if (amount != 0.0) {
                      double pricePerUnit = priceTotal / amount;
                      viewModel.priceUnitController.text =
                          pricePerUnit.toStringAsFixed(2);
                    }
                  },
                  hasLabel: false,
                  hasTitle: false,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tarih Seçimi
          CustomDatePickerWidget(
            viewModel: viewModel,
            validator: checkDateTime,
          ),
        ],
      ),
    );
  }

  Widget _buildBuyButton(GlobalKey<FormState> tradeFormKey,
      TradeViewModel viewModel, BuildContext context, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (!tradeFormKey.currentState!.validate()) {
            EasySnackBar.show(context, LocaleKeys.trade_fillAllFields.tr());
            return;
          }
          viewModel.buyCurrency(ref: ref, context: context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon: const Icon(Icons.shopping_cart_outlined, size: 20),
        label: const Text(
          "Cüzdan'a ekle",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

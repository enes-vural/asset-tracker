import 'package:asset_tracker/core/constants/enums/widgets/trade_type_enum.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/helpers/dialog_helper.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/common/custom_datepicker_widget.dart';
import 'package:asset_tracker/presentation/common/custom_dropdown_widget.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_form_widget.dart';
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
      body: Form(
        key: tradeFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTradeTypeToggle(isDark, viewModel),
              const SizedBox(height: 16),
              _buildTradeForm(viewModel, isDark),
              const SizedBox(height: 24),
              _buildActionButton(tradeFormKey, viewModel, context, isDark),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradeTypeToggle(bool isDark, TradeViewModel viewModel) {
    final currentTradeType = viewModel.currentTradeType;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => viewModel.toggleTradeType(ref, TradeType.buy),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: currentTradeType == TradeType.buy
                      ? Colors.green[600]
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: currentTradeType == TradeType.buy
                          ? Colors.white
                          : (isDark ? Colors.green[400] : Colors.green[600]),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ALIM',
                      style: TextStyle(
                        color: currentTradeType == TradeType.buy
                            ? Colors.white
                            : (isDark ? Colors.green[400] : Colors.green[600]),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
              onTap: () => viewModel.toggleTradeType(ref, TradeType.sell),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: currentTradeType == TradeType.sell
                      ? Colors.red[600]
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.trending_down,
                      color: currentTradeType == TradeType.sell
                          ? Colors.white
                          : (isDark ? Colors.red[400] : Colors.red[600]),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SATIM',
                      style: TextStyle(
                        color: currentTradeType == TradeType.sell
                            ? Colors.white
                            : (isDark ? Colors.red[400] : Colors.red[600]),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeForm(TradeViewModel viewModel, bool isDark) {
    final currentTradeType = viewModel.currentTradeType;

    // Dark theme için uygun renkler
    final buyColors = isDark
        ? {
            'background': const Color(0xFF1A2E1A), // Koyu yeşil arkaplan
            'border': const Color(0xFF2E5D2E), // Orta yeşil border
            'text': const Color(0xFF4CAF50), // Açık yeşil text
          }
        : {
            'background': Colors.green[50]!,
            'border': Colors.green[200]!,
            'text': Colors.green[800]!,
          };

    final sellColors = isDark
        ? {
            'background': const Color(0xFF2E1A1A), // Koyu kırmızı arkaplan
            'border': const Color(0xFF5D2E2E), // Orta kırmızı border
            'text': const Color(0xFFE57373), // Açık kırmızı text
          }
        : {
            'background': Colors.red[50]!,
            'border': Colors.red[200]!,
            'text': Colors.red[800]!,
          };

    final currentColors =
        currentTradeType == TradeType.buy ? buyColors : sellColors;

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
          Row(
            children: [
              Icon(
                currentTradeType == TradeType.buy
                    ? Icons.add_shopping_cart
                    : Icons.sell,
                color: currentTradeType == TradeType.buy
                    ? (isDark ? const Color(0xFF4CAF50) : Colors.green[600])
                    : (isDark ? const Color(0xFFE57373) : Colors.red[600]),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                currentTradeType == TradeType.buy
                    ? 'Alım İşlemi Detayları'
                    : 'Satım İşlemi Detayları',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Token Seçimi
          CustomDropDownWidget(
            pageCurrency: widget.currencyCode,
            viewModel: viewModel,
            onSelectedChanged: () {
              debugPrint("aljfljasfn");
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
            label: "Adet Fiyatı (TL)",
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
              color: currentColors['background'] as Color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: currentColors['border'] as Color,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toplam Fiyat',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: currentColors['text'] as Color,
                  ),
                ),
                const SizedBox(height: 4),
                AuthFormWidget(
                  label: "Toplam Fiyat (TL)",
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

  Widget _buildActionButton(GlobalKey<FormState> tradeFormKey,
      TradeViewModel viewModel, BuildContext context, bool isDark) {
    final currentTradeType = viewModel.currentTradeType;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (!tradeFormKey.currentState!.validate()) {
            EasySnackBar.show(context, LocaleKeys.trade_fillAllFields.tr());
            return;
          }
          if (currentTradeType == TradeType.buy) {
            await viewModel.buyCurrency(ref: ref, context: context);
          } else if (currentTradeType == TradeType.sell) {
            await viewModel.sellCurrency(ref: ref, context: context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: currentTradeType == TradeType.buy
              ? Colors.green[600]
              : Colors.red[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon: Icon(
          currentTradeType == TradeType.buy
              ? Icons.add_shopping_cart
              : Icons.sell,
          size: 20,
        ),
        label: Text(
          currentTradeType == TradeType.buy
              ? "Cüzdan'a Ekle"
              : "Cüzdan'dan Sat",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

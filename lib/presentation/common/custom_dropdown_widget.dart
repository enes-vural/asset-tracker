import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/presentation/view_model/home/trade/trade_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDownWidget<T> extends ConsumerStatefulWidget {
  const CustomDropDownWidget({
    super.key,
    required this.pageCurrency,
    required this.viewModel,
    required this.onSelectedChanged,
  });

  final String? pageCurrency;
  final TradeViewModel viewModel;
  final VoidCallback? onSelectedChanged;

  @override
  ConsumerState<CustomDropDownWidget<T>> createState() =>
      _CustomDropDownWidgetState<T>();
}

class _CustomDropDownWidgetState<T>
    extends ConsumerState<CustomDropDownWidget<T>> {
  late TextEditingController _controller;
  List<String> _filteredList = [];
  List<String> _allCurrencies = [];
  String? _selectedValue;
  bool _showSuggestions = false;
  bool _isUserTyping = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _initializeCurrencies();
  }

  void _initializeCurrencies() {
    // Currency listesini al ve çevir
    final currencyLabels = widget.viewModel
        .getCurrencyList(ref)
        .map((e) => setCurrencyLabel(e.code))
        .toList();
    
    // Tekrar eden değerleri temizle
    _allCurrencies = currencyLabels.toSet().toList();
    _filteredList = List.from(_allCurrencies);
    _updateSelectedValue(widget.pageCurrency);
  }

  void _updateSelectedValue(String? newValue) {
    if (!_isUserTyping) {
      _selectedValue = newValue;
      if (_selectedValue != null) {
        _controller.text = _selectedValue!;
      } else {
        _controller.clear();
      }
    }
  }

  @override
  void didUpdateWidget(CustomDropDownWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // pageCurrency değiştiğinde controller'ı güncelle
    if (oldWidget.pageCurrency != widget.pageCurrency) {
      _updateSelectedValue(widget.pageCurrency);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _isUserTyping = true;
    setState(() {
      // Filtreleme yaparken de tekrar eden değerleri temizle
      _filteredList = _allCurrencies
          .where((item) => item.toLowerCase().contains(value.toLowerCase()))
          .toSet() // Tekrar eden değerleri temizle
          .toList();

      if (_filteredList.length == 1 &&
          value.toLowerCase() == _filteredList[0].toLowerCase()) {
        _selectedValue = _filteredList[0];
        widget.viewModel.changeSelectedCurrency(_selectedValue);
      } else {
        _selectedValue = null;
        widget.viewModel.changeSelectedCurrency(null);
      }
    });
  }

  void _onItemTap(String value) {
    _isUserTyping = false;
    setState(() {
      _controller.text = value;
      _controller.selection = TextSelection.collapsed(offset: value.length);
      _selectedValue = value;
      _filteredList = _allCurrencies;
      _showSuggestions = false;
    });
    // ViewModel'i güncelle
    widget.viewModel.changeSelectedCurrency(value);

    widget.viewModel.getPriceSelectedCurrency(ref);

    // Focus'u kaldır
    FocusScope.of(context).unfocus();
  }

  void _onFocusChanged(bool hasFocus) {
    setState(() {
      // Focus aldığında tüm listeyi göster (ilk tıklamada itemler çıksın)
      _showSuggestions = hasFocus;
      if (hasFocus) {
        // Focus alındığında tüm listeyi göster
        _filteredList = _allCurrencies;
      } else {
        _isUserTyping = false;
        _filteredList = _allCurrencies;
        // Focus kaybedildiğinde, eğer geçerli bir seçim yoksa controller'ı düzelt
        if (_selectedValue != null && _controller.text != _selectedValue) {
          _controller.text = _selectedValue!;
        } else if (_selectedValue == null) {
          _controller.clear();
        }
      }
    });
  }

  // Border rengini tema durumuna göre belirleyen fonksiyon
  Color _getInputBorderColor(ThemeData theme, bool isDarkMode) {
    if (isDarkMode) {
      return theme.colorScheme.outline.withOpacity(0.5);
    } else {
      return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tema ve dark mode bilgilerini al
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // ViewModel'daki selectedCurrency değişikliklerini dinle
    final currentSelectedCurrency = widget.viewModel.selectedCurrency;

    // Eğer viewModel'daki değer değiştiyse ve kullanıcı yazmıyorsa güncelle
    if (currentSelectedCurrency != _selectedValue &&
        !_isUserTyping &&
        !_showSuggestions) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateSelectedValue(currentSelectedCurrency);
      });
    }

    return CustomPadding.largeTop(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.home_unit.tr(),
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: AppSize.smallText2,
              fontWeight: FontWeight.normal,
              height: 1.5,
            ),
          ),
          const CustomSizedBox.smallGap(),
          Focus(
            onFocusChange: _onFocusChanged,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.mediumRadius),
                  borderSide: BorderSide(
                    color: _getInputBorderColor(theme, isDarkMode),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.mediumRadius),
                  borderSide: BorderSide(
                    color: _getInputBorderColor(theme, isDarkMode),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.mediumRadius),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              onChanged: _onChanged,
            ),
          ),
          if (_showSuggestions && _filteredList.isNotEmpty)
            Container(
              constraints: BoxConstraints(maxHeight: 200.h),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(AppSize.mediumRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Kaydırma ipucu - sadece liste çok uzunsa göster
                  if (_filteredList.length > 4)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.swipe_vertical,
                            size: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Kaydırın",
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredList.length,
                      itemBuilder: (context, index) {
                        final value = _filteredList[index];
                        return ListTile(
                          title: Text(value),
                          onTap: () => _onItemTap(value),
                          selected: value == _selectedValue,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

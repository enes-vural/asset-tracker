import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/presentation/view_model/home/trade/trade_view_model.dart';
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
    _allCurrencies =
        widget.viewModel.getCurrencyList(ref).map((e) => e.code).toList();
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
      _filteredList = _allCurrencies
          .where((item) => item.toLowerCase().contains(value.toLowerCase()))
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

    // if (widget.onSelectedChanged != null) {
    //   widget.onSelectedChanged!();
    // }

    widget.viewModel.getPriceSelectedCurrency(ref);

    // Focus'u kaldır
    FocusScope.of(context).unfocus();
  }

  void _onFocusChanged(bool hasFocus) {
    setState(() {
      _showSuggestions = hasFocus;
      if (!hasFocus) {
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

  @override
  Widget build(BuildContext context) {
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
            "Asset Type",
            style: TextStyle(
              color: DefaultColorPalette.mainTextBlack,
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
                filled: true,
                fillColor: DefaultColorPalette.customGreyLightX,
                enabledBorder: CustomInputDecoration.defaultInputBorder(),
                focusedBorder: CustomInputDecoration.focusedInputBorder(),
                errorBorder: CustomInputDecoration.errorInputBorder(),
                focusedErrorBorder: CustomInputDecoration.errorInputBorder(),
              ),
              onChanged: _onChanged,
            ),
          ),
          if (_showSuggestions &&
              _controller.text.isNotEmpty &&
              _filteredList.isNotEmpty)
            Container(
              constraints: BoxConstraints(maxHeight: 200.h),
              decoration: BoxDecoration(
                color: DefaultColorPalette.vanillaWhite,
                border: Border.all(color: DefaultColorPalette.customGreyLight),
                borderRadius: BorderRadius.circular(AppSize.mediumRadius),
              ),
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
    );
  }
}

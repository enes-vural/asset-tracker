import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/widgets/custom_icon.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/presentation/view_model/home/trade/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDownWidget<T> extends StatefulWidget {
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
  State<CustomDropDownWidget<T>> createState() =>
      _CustomDropDownWidgetState<T>();
}

class _CustomDropDownWidgetState<T> extends State<CustomDropDownWidget<T>> {
  late TextEditingController _controller;
  List<String> _filteredList = [];
  List<String> _allCurrencies = [];
  String? _selectedValue;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _allCurrencies = widget.viewModel
        .getCurrencyList(widget.ref)
        .map((e) => e.code)
        .toList();
    _filteredList = List.from(_allCurrencies);
    _selectedValue = widget.pageCurrency;
    if (_selectedValue != null) {
      _controller.text = _selectedValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
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
    setState(() {
      _controller.text = value;
      _selectedValue = value;
      widget.viewModel.changeSelectedCurrency(value);
      _filteredList = _allCurrencies;
      _showSuggestions = false;
      FocusScope.of(context).unfocus();
    });
  }

  void _onFocusChanged(bool hasFocus) {
    setState(() {
      _showSuggestions = hasFocus;
      if (!hasFocus) {
        // Başka bir forma tıklandığında suggestion'ı gizle
        _filteredList = _allCurrencies;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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

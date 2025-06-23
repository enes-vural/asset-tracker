import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/presentation/view_model/home/trade/trade_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDatePickerWidget extends StatelessWidget {
  const CustomDatePickerWidget({
    super.key,
    this.label = "Date",
    this.validator,
    required this.viewModel,
  });

  final TradeViewModel viewModel;

  final String label;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Tema renklerini belirle
    final titleColor = _getTitleColor(theme, isDarkMode);
    final inputBackgroundColor = _getInputBackgroundColor(theme, isDarkMode);
    final inputBorderColor = _getInputBorderColor(theme, isDarkMode);
    final hintColor = _getHintColor(theme, isDarkMode);

    return CustomPadding.largeTop(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: titleColor,
              fontFamily: 'Manrope',
              fontSize: AppSize.smallText2,
              fontWeight: FontWeight.normal,
              height: 1.5,
            ),
          ),
          const CustomSizedBox.smallGap(),
          Theme(
            data: theme.copyWith(
              inputDecorationTheme: theme.inputDecorationTheme.copyWith(
                fillColor: inputBackgroundColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: inputBorderColor,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.primaryColor,
                    width: 2.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: 2.0,
                  ),
                ),
                hintStyle: TextStyle(
                  color: hintColor,
                  fontFamily: 'Manrope',
                ),
              ),
            ),
            child: TextFormField(
              controller: viewModel.dateController,
              validator: validator,
              keyboardType: TextInputType.datetime,
              inputFormatters: [
                _DateInputFormatter(),
              ],
              onChanged: (value) {
                // Tarih formatını kontrol et ve güncelle
                if (value.length == 10) {
                  try {
                    final date = DateFormat('dd/MM/yyyy').parseStrict(value);
                    viewModel.changeSelectedDate(date);
                  } catch (e) {
                    // Hatalı format varsa ignore
                  }
                } else if (value.isEmpty) {
                  viewModel.changeSelectedDate(null);
                }
              },
              readOnly: false, // Elle yazmaya izin ver
              decoration: InputDecoration(
                hintText: 'gün/ay/yıl',
                hintStyle: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: AppSize.smallText2,
                  fontWeight: FontWeight.normal,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: DefaultColorPalette.customGrey,
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: viewModel.selectedDate ?? DateTime.now(),
                      firstDate: DateTime(0000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      viewModel.changeSelectedDate(picked);
                      viewModel.dateController.text =
                          DateFormat('dd/MM/yyyy').format(picked);
                    }
                  },
                ),
              ),
              onTap: () {}, // Elle yazma ve ikon ile seçim birlikte çalışır
            ),
          ),
        ],
      ),
    );
  }

  // Tema renklerini belirleyen yardımcı metodlar
  Color _getTitleColor(ThemeData theme, bool isDarkMode) {
    if (isDarkMode) {
      return DefaultColorPalette.vanillaWhite;
    } else {
      return DefaultColorPalette.mainTextBlack;
    }
  }

  Color _getInputBackgroundColor(ThemeData theme, bool isDarkMode) {
    if (isDarkMode) {
      return theme.colorScheme.surface.withOpacity(0.8);
    } else {
      return Colors.white;
    }
  }

  Color _getInputBorderColor(ThemeData theme, bool isDarkMode) {
    if (isDarkMode) {
      return theme.colorScheme.outline.withOpacity(0.5);
    } else {
      return Colors.grey.shade300;
    }
  }

  Color _getHintColor(ThemeData theme, bool isDarkMode) {
    if (isDarkMode) {
      return theme.colorScheme.onSurface.withOpacity(0.6);
    } else {
      return Colors.grey.shade500;
    }
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 8) text = text.substring(0, 8);
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i == 1 || i == 3) && i != text.length - 1) buffer.write('/');
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// ignore_for_file: use_key_in_widget_constructors

import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';

class AuthFormWidget extends StatelessWidget {
  const AuthFormWidget({
    super.key,
    required this.label,
    required this.isObs,
    required this.formController,
    required this.validaor,
    this.hasTitle = false,
    this.hasLabel = true,
    this.type = TextInputType.text,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.isRequired = true,
  });

  final String label;
  final TextEditingController? formController;
  final FormFieldValidator<String>? validaor;
  final bool isObs;
  final bool hasTitle;
  final bool hasLabel;
  final TextInputType type;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool isRequired;
  final void Function(String)? onFieldSubmitted;

  AuthFormWidget.email({
    Key? key,
    required TextEditingController? emailController,
    required FormFieldValidator<String>? emailValidator,
    required bool hasTitle,
    required bool hasLabel,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) : this(
          key: key,
          formController: emailController,
          isObs: false,
          label: LocaleKeys.auth_email.tr(),
          validaor: emailValidator,
          hasTitle: hasTitle,
          hasLabel: hasLabel,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
        );

  AuthFormWidget.password({
    Key? key,
    required TextEditingController? passwordController,
    required FormFieldValidator<String>? passwordValidator,
    required bool hasTitle,
    required bool hasLabel,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) : this(
          key: key,
          formController: passwordController,
          isObs: true,
          label: LocaleKeys.auth_password.tr(),
          validaor: passwordValidator,
          hasTitle: hasTitle,
          hasLabel: hasLabel,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
        );

  AuthFormWidget.firstName({
    Key? key,
    required TextEditingController? firstNameController,
    required FormFieldValidator<String>? firstNameValidator,
    required bool hasTitle,
    required bool hasLabel,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) : this(
          key: key,
          formController: firstNameController,
          isObs: false,
          label: LocaleKeys.auth_firstName.tr(),
          validaor: firstNameValidator,
          hasTitle: hasTitle,
          hasLabel: hasLabel,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
        );

  AuthFormWidget.lastName({
    Key? key,
    required TextEditingController? lastNameController,
    required FormFieldValidator<String>? lastNameValidator,
    required bool hasTitle,
    required bool hasLabel,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
    required bool isRequired,
  }) : this(
          key: key,
          formController: lastNameController,
          isObs: false,
          label: LocaleKeys.auth_lastName.tr(),
          validaor: lastNameValidator,
          isRequired: false,
          hasTitle: hasTitle,
          hasLabel: hasLabel,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
        );

  @override
  Widget build(BuildContext context) {
    // Tema bilgisini al
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Tema renklerini belirle
    final titleColor = _getTitleColor(theme, isDarkMode);
    final inputBackgroundColor = _getInputBackgroundColor(theme, isDarkMode);
    final inputBorderColor = _getInputBorderColor(theme, isDarkMode);
    final inputTextColor = _getInputTextColor(theme, isDarkMode);
    final hintColor = _getHintColor(theme, isDarkMode);

    return CustomPadding.largeTop(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTitle)
            Text(
              label + (isRequired ? "*" : ""),
              style: TextStyle(
                color: titleColor,
                fontFamily: 'Manrope',
                fontSize: AppSize.smallText2,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          const CustomSizedBox.smallGap(),
          SizedBox(
            width: ResponsiveSize(context).screenWidth,
            child: Theme(
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
                decoration: InputDecoration(
                  hint: Text(
                    hasLabel ? label : DefaultLocalStrings.emptyText,
                  ),
                ),
                textInputAction: textInputAction,
                onFieldSubmitted: onFieldSubmitted,
                focusNode: focusNode,
                onChanged: onChanged,
                obscureText: isObs,
                keyboardType: type,
                controller: formController,
                validator: validaor,
                style: TextStyle(
                  color: inputTextColor,
                  fontFamily: 'Manrope',
                ),
              ),
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

  Color _getInputTextColor(ThemeData theme, bool isDarkMode) {
    if (isDarkMode) {
      return theme.colorScheme.onSurface;
    } else {
      return DefaultColorPalette.mainTextBlack;
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

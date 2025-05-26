// ignore_for_file: use_key_in_widget_constructors

import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:flutter/services.dart';

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
  });

  final String label;
  final TextEditingController? formController;
  final FormFieldValidator<String>? validaor;
  final bool isObs;
  final bool hasTitle;
  final bool hasLabel;
  final TextInputType type;
  final ValueChanged<String>? onChanged;

  AuthFormWidget.email({
    Key? key,
    required TextEditingController? emailController,
    required FormFieldValidator<String>? emailValidator,
    required bool hasTitle,
    required bool hasLabel,
  }) : this(
          key: key,
          formController: emailController,
          isObs: false,
          label: LocaleKeys.auth_email.tr(),
          validaor: emailValidator,
          hasTitle: hasTitle,
          hasLabel: hasLabel,
        );

  AuthFormWidget.password({
    Key? key,
    required TextEditingController? passwordController,
    required FormFieldValidator<String>? passwordValidator,
    required bool hasTitle,
    required bool hasLabel,
  }) : this(
          key: key,
          formController: passwordController,
          isObs: true,
          label: LocaleKeys.auth_password.tr(),
          validaor: passwordValidator,
          hasTitle: hasTitle,
          hasLabel: hasLabel,
        );

  const AuthFormWidget.firstName({
    Key? key,
    required TextEditingController? firstNameController,
    required FormFieldValidator<String>? firstNameValidator,
    required bool hasTitle,
    required bool hasLabel,
  }) : this(
            key: key,
            formController: firstNameController,
            isObs: false,
            label: "First name",
            validaor: firstNameValidator,
            hasTitle: hasTitle,
            hasLabel: hasLabel);

  const AuthFormWidget.lastName({
    Key? key,
    required TextEditingController? lastNameController,
    required FormFieldValidator<String>? lastNameValidator,
    required bool hasTitle,
    required bool hasLabel,
  }) : this(
          key: key,
          formController: lastNameController,
          isObs: false,
          label: "Last name",
          validaor: lastNameValidator,
          hasTitle: hasTitle,
          hasLabel: hasLabel, 
        );

  @override
  Widget build(BuildContext context) {
    return CustomPadding.largeTop(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTitle)
            Text(
              label,
              style: TextStyle(
                color: DefaultColorPalette.mainTextBlack,
                fontFamily: 'Manrope',
                fontSize: AppSize.smallText2,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          const CustomSizedBox.smallGap(),
          SizedBox(
            width: ResponsiveSize(context).screenWidth,
            child: TextFormField(
              onChanged: onChanged,
              obscureText: isObs,
              keyboardType: type,
              controller: formController,
              validator: validaor,
              decoration: CustomInputDecoration.mediumRoundInput(
                  label: label,
                hasLabel: hasLabel
              ),
            ),
          ),
        ],
      ),
    );
  }
}

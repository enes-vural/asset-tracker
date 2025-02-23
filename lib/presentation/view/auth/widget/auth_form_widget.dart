// ignore_for_file: use_key_in_widget_constructors


import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
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
  });

  final String label;
  final TextEditingController? formController;
  final FormFieldValidator<String>? validaor;
  final bool isObs;


  AuthFormWidget.email({
    Key? key,
    required TextEditingController? emailController,
    required FormFieldValidator<String>? emailValidator,
  }) : this(
          key: key,
          formController: emailController,
          isObs: false,
          label: LocaleKeys.auth_email.tr(),
          validaor: emailValidator,
        );

  AuthFormWidget.password({
    Key? key,
    required TextEditingController? passwordController,
    required FormFieldValidator<String>? passwordValidator,
  }) : this(
          key: key,
          formController: passwordController,
          isObs: true,
          label: LocaleKeys.auth_password.tr(),
          validaor: passwordValidator,
        );

  @override
  Widget build(BuildContext context) {
    return CustomPadding.largeTop(
      widget: SizedBox(
        width: ResponsiveSize(context).screenWidth,
        child: TextFormField(
          obscureText: isObs,
          controller: formController,
          validator: validaor,
          decoration: CustomInputDecoration.mediumRoundInput(label: label),
        ),
      ),
    );
  }
}

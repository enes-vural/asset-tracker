// ignore_for_file: use_key_in_widget_constructors

import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:flutter/material.dart';

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


  const AuthFormWidget.email({
    required TextEditingController? emailController,
    required FormFieldValidator<String>? emailValidator,
  }) : this(
          formController: emailController,
          isObs: false,
          label: DefaultLocalStrings.emailText,
          validaor: emailValidator,
        );

  const AuthFormWidget.password({
    required TextEditingController? passwordController,
    required FormFieldValidator<String>? passwordValidator,
  }) : this(
          formController: passwordController,
          isObs: true,
          label: DefaultLocalStrings.passwordText,
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

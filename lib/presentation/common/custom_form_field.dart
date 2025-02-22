import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
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

  CustomFormField.countForm({
    Key? key,
    required TextEditingController? emailController,
    required FormFieldValidator<String>? emailValidator,
  }) : this(
          key: key,
          formController: emailController,
          isObs: false,
          label: 'Asset Count',
          validaor: emailValidator,
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

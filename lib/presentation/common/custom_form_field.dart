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
    this.type = TextInputType.text,
    this.icon,
  });

  final String label;
  final TextEditingController? formController;
  final FormFieldValidator<String>? validaor;
  final bool isObs;
  final TextInputType type;
  final IconData? icon;

  const CustomFormField.countForm({
    Key? key,
    required TextEditingController? controller,
    required FormFieldValidator<String>? validator,
    required String label,
    required TextInputType type,
    IconData? icon,
  }) : this(
          key: key,
          formController: controller,
          isObs: false,
          label: label,
          validaor: validator,
          type: type,
          icon: icon,
        );

  @override
  Widget build(BuildContext context) {
    return CustomPadding.largeTop(
      widget: SizedBox(
        width: ResponsiveSize(context).screenWidth,
        child: TextFormField(
          keyboardType: TextInputType.number,
          obscureText: isObs,
          controller: formController,
          validator: validaor,
          decoration:
              CustomInputDecoration.mediumRoundInput(label: label, icon: icon),
        ),
      ),
    );
  }
}

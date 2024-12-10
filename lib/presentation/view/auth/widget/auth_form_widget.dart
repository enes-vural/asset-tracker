import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
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

  ///* first param: TextEditing Controller
  ///* second param: FormFieldValidator<String>? validator
  factory AuthFormWidget.email(TextEditingController? emailController,
      FormFieldValidator<String>? emailValiator) {
    return AuthFormWidget(
      label: DefaultLocalStrings.emailText,
      isObs: false,
      formController: emailController,
      validaor: emailValiator,
    );
  }

  ///* first param: TextEditing Controller
  ///* second param: FormFieldValidator<String>? validator
  factory AuthFormWidget.password(TextEditingController? passController,
      FormFieldValidator<String>? passValidator) {
    return AuthFormWidget(
      label: DefaultLocalStrings.passwordText,
      isObs: true,
      formController: passController,
      validaor: passValidator,
    );
  }


  @override
  Widget build(BuildContext context) {
    return CustomPadding.onlyTop(
      padding: AppSize.largePadd,
      child: SizedBox(
        width: ResponsiveSize(context).screenWidth,
        child: TextFormField(
          obscureText: isObs,
          controller: formController,
          validator: validaor,
          decoration: InputDecoration(
              label: Text(label),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              )),
        ),
      ),
    );
  }
}

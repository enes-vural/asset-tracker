import 'package:flutter/material.dart';

class AuthFormWidget extends StatelessWidget {
  const AuthFormWidget({
    super.key,
    required this.label,
    required this.isObs,
    required this.size,
    required this.formController,
    required this.validaor,
  });

  final Size size;
  final String label;
  final TextEditingController? formController;
  final FormFieldValidator<String>? validaor;
  final bool isObs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
        width: size.width,
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

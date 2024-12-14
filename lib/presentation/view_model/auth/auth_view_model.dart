import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final SignInUseCase signInUseCase;

  AuthViewModel({required this.signInUseCase});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  clearForms() {
    emailController.text = DefaultLocalStrings.emptyText;
    passwordController.text = DefaultLocalStrings.emptyText;
    notifyListeners();
  }

  Future signInUser(BuildContext context, VoidCallback onLoginSuccess) async {
    final UserLoginEntity userEntity = UserLoginEntity(
        userName: emailController.text, password: passwordController.text);

    final result = await signInUseCase.call(userEntity);

    result.fold(
      (failure) {
        EasySnackBar.show(context, failure.message);
      },
      (success) {
        onLoginSuccess();
      },
    );
  }
}

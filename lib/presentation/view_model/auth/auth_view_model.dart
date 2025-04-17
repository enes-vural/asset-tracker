import 'package:asset_tracker/core/config/constants/global/key/fom_keys.dart';
import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_login_entity.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_register_entity.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthViewModel extends ChangeNotifier {
  final SignInUseCase signInUseCase;

  AuthViewModel({required this.signInUseCase});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _clearForms() {
    emailController.text = DefaultLocalStrings.emptyText;
    passwordController.text = DefaultLocalStrings.emptyText;
    notifyListeners();
  }

  routeRegisterView(BuildContext context) {
    Routers.instance.pushReplaceNamed(context, Routers.registerPath);
  }

  Future registerUser(WidgetRef ref, BuildContext context) async {
    if (!(GlobalFormKeys.registerFormsKey.currentState?.validate() ?? true)) {
      return;
    }
    final UserRegisterEntity userEntity = UserRegisterEntity(
        userName: emailController.text, password: passwordController.text);

    final result = await signInUseCase.registerUser(userEntity);

    result.fold(
      (failure) {
        EasySnackBar.show(context, failure.message);
        _clearForms();
      },
      (success) {
        _clearForms();
        EasySnackBar.show(
            context, "Your account has been created successfully");
        Routers.instance.popToSplash(context);
      },
    );
  }

  Future signInUser(WidgetRef ref, BuildContext context) async {
    if (!(GlobalFormKeys.loginFormsKey.currentState?.validate() ?? true)) {
      return;
    }
    final UserLoginEntity userEntity = UserLoginEntity(
        userName: emailController.text, password: passwordController.text);

    final result = await signInUseCase.call(userEntity);

    result.fold((failure) => EasySnackBar.show(context, failure.message),
        (success) async {
      _clearForms();
      Routers.instance.popToSplash(context);
    });
  }
}

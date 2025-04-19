import 'package:asset_tracker/core/constants/enums/auth/auth_error_state_enums.dart';
import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/core/constants/global/key/fom_keys.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_login_entity.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_register_entity.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthViewModel extends ChangeNotifier {
  final SignInUseCase signInUseCase;

  AuthViewModel({required this.signInUseCase});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _changeProcessingState({required WidgetRef ref, required bool canPop}) {
    ref.read(isAuthProcessingProvider.notifier).state = canPop;
    notifyListeners();
  }

  _clearForms() {
    emailController.text = DefaultLocalStrings.emptyText;
    passwordController.text = DefaultLocalStrings.emptyText;
    notifyListeners();
  }

  routeRegisterView(BuildContext context) {
    Routers.instance.pushReplaceNamed(context, Routers.registerPath);
  }

  //We wont use offline support for register. The user may be confused
  Future registerUser(WidgetRef ref, BuildContext context) async {
    if (!(GlobalFormKeys.registerFormsKey.currentState?.validate() ?? true)) {
      return;
    }
    _changeProcessingState(ref: ref, canPop: false);
    final UserRegisterEntity userEntity = UserRegisterEntity(
        userName: emailController.text, password: passwordController.text);

    final result = await signInUseCase.registerUser(userEntity);
    _changeProcessingState(ref: ref, canPop: true);
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
    _changeProcessingState(ref: ref, canPop: false);
    final UserLoginEntity userEntity = UserLoginEntity(
        userName: emailController.text, password: passwordController.text);

    //SAVE OFFLINE FIRST
    final cachedKey = await ref
        .read(cacheUseCaseProvider)
        .saveOfflineAction(Tuple2(OfflineActionType.LOGIN, userEntity));

    final result = await signInUseCase.call(userEntity);

    _changeProcessingState(ref: ref, canPop: true);
    result.fold((failure) {
      if (failure.state != AuthErrorState.NETWORK_ERROR) {
        ref.read(cacheUseCaseProvider).removeOfflineAction(cachedKey);
      }
      EasySnackBar.show(context, failure.message);
    },
        (success) async {
      ref.read(cacheUseCaseProvider).removeOfflineAction(cachedKey);
      _clearForms();
      Routers.instance.popToSplash(context);
    });
  }
}

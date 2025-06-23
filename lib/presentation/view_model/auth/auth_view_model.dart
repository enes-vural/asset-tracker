import 'package:asset_tracker/core/constants/enums/auth/auth_error_state_enums.dart';
import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/core/routers/app_router.gr.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_login_entity.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_register_entity.dart';
import 'package:asset_tracker/domain/entities/auth/response/user_register_reponse_entity.dart';
import 'package:asset_tracker/domain/entities/database/request/save_user_entity.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:asset_tracker/domain/usecase/cache/cache_use_case.dart';
import 'package:asset_tracker/domain/usecase/database/database_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthUseCase authUseCase;

  AuthViewModel({required this.authUseCase});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  bool canPop = true;

  changePopState(bool value) {
    if (value == canPop) return;
    canPop = value;
    notifyListeners();
  }

  _clearForms() {
    emailController.text = DefaultLocalStrings.emptyText;
    passwordController.text = DefaultLocalStrings.emptyText;
    firstNameController.text = DefaultLocalStrings.emptyText;
    lastNameController.text = DefaultLocalStrings.emptyText;
    notifyListeners();
  }

  routeRegisterView(BuildContext context) {
    Routers.instance.pushNamed(context, Routers.registerPath);
  }

  routeForgotPasswordView(BuildContext context) {
    Routers.instance.pushNamed(context, Routers.forgotPasswordPath);
  }

  Future<void> sendResetEmailLink() async {
    if (emailController.text.isNotEmpty) {
      return await authUseCase.sendResetPasswordLink(emailController.text);
    }
  }

  //We wont use offline support for register. The user may be confused
  Future registerUser(WidgetRef ref, BuildContext context) async {
    changePopState(false);
    final UserRegisterEntity userEntity = UserRegisterEntity(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      userName: emailController.text,
      password: passwordController.text,
    );

    final result = await authUseCase.registerUser(userEntity);
    result.fold(
      (failure) {
        changePopState(true);
        EasySnackBar.show(context, failure.message);
      },
      (UserRegisterReponseEntity success) async {
        final saveUserEntity = SaveUserEntity.fromAuthResponse(
            success, firstNameController.text, lastNameController.text);
        final status =
            await getIt<DatabaseUseCase>().saveUserData(saveUserEntity);
        _clearForms();
        changePopState(true);
        status.fold((error) {
          EasySnackBar.show(context, error.message);
        }, (success) {
          debugPrint("User data saved successfully");
          EasySnackBar.show(
              context, "Your account has been created successfully");
          Routers.instance.popToSplash(context);
        });
      },
    );
  }

  Future signInUser(WidgetRef ref, BuildContext context) async {
    changePopState(false);
    final UserLoginEntity userEntity = UserLoginEntity(
      userName: emailController.text,
      password: passwordController.text,
    );

    //SAVE OFFLINE FIRST
    final cachedKey = await getIt<CacheUseCase>()
        .saveOfflineAction(Tuple2(OfflineActionType.LOGIN, userEntity));

    final result = await authUseCase.call(userEntity);

    await result.fold((failure) {
      if (failure.state != AuthErrorState.NETWORK_ERROR) {
        getIt<CacheUseCase>().removeOfflineAction(cachedKey);
      }
      EasySnackBar.show(context, failure.message);
      changePopState(true);
    }, (success) async {
      await getIt<CacheUseCase>().removeOfflineAction(cachedKey);
      _clearForms();
      changePopState(true);
      Routers.instance.pushAndRemoveUntil(context, const SplashRoute());
    });
  }
}

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/constants/global/key/fom_keys.dart';
import 'package:asset_tracker/core/helpers/dialog_helper.dart';
import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/core/widgets/custom_align.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_form_widget.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_submit_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/circle_logo_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView>
    with ValidatorMixin {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(authViewModelProvider);

    EasyDialog.showDialogOnProcess(context, ref, authViewModelProvider);

    return PopScope(
      canPop: viewModel.canPop,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(LocaleKeys.auth_register.tr()),
          ),
          body: CustomPadding.largeHorizontal(
            widget: Form(
              autovalidateMode: AutovalidateMode.always,
              key: GlobalFormKeys.registerFormsKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomSizedBox.hugeGap(),
                  const Center(child: CircleMainLogoWidget()),
                  const CustomSizedBox.hugeGap(),
                  CustomAlign.centerLeft(
                      child: Text(LocaleKeys.auth_registerTitle.tr())),
                  AuthFormWidget.email(
                    emailController: viewModel.emailController,
                    emailValidator: checkEmail,
                  ),
                  const CustomSizedBox.smallGap(),
                  AuthFormWidget.password(
                    passwordController: viewModel.passwordController,
                    passwordValidator: checkPassword,
                  ),
                  const CustomSizedBox.hugeGap(),
                  AuthSubmitWidget(
                      label: LocaleKeys.auth_register.tr(),
                      voidCallBack: () async =>
                          await viewModel.registerUser(ref, context)),
                ],
              ),
            ),
          )),
    );
  }
}

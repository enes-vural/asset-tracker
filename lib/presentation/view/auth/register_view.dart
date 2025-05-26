import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/helpers/dialog_helper.dart';
import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_form_widget.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_submit_widget.dart';
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
    final GlobalKey<FormState> registerFormsKey = GlobalKey<FormState>();
    final viewModel = ref.watch(authViewModelProvider);

    EasyDialog.showDialogOnProcess(context, ref, authViewModelProvider);

    return PopScope(
      canPop: viewModel.canPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: true,
            elevation: 0,
            title: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Finaks",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromRGBO(17, 20, 22, 1),
                    fontFamily: 'Manrope',
                    fontSize: 22,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          body: CustomPadding.smallHorizontal(
            widget: Form(
              key: registerFormsKey,
              child: CustomPadding.largeAll(
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Create your account',
                        style: TextStyle(
                          color: Color.fromRGBO(17, 20, 22, 1),
                          fontFamily: 'Manrope',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.27,
                        ),
                      ),
                    ),

                    const CustomSizedBox.smallGap(),

                    // Email Field
                    AuthFormWidget.email(
                      emailController: viewModel.emailController,
                      emailValidator: checkEmail,
                      hasTitle: true,
                      hasLabel: false,
                    ),
                    const CustomSizedBox.smallGap(),
                    AuthFormWidget.password(
                      passwordController: viewModel.passwordController,
                      passwordValidator: checkPassword,
                      hasTitle: true,
                      hasLabel: false,
                    ),

                    const CustomSizedBox.smallGap(),
                    // Password Field
                    AuthFormWidget.firstName(
                      firstNameController: viewModel.firstNameController,
                      firstNameValidator: checkText,
                      hasTitle: true,
                      hasLabel: false,
                    ),

                    const CustomSizedBox.smallGap(),
                    // First Name Field
                    AuthFormWidget.lastName(
                      lastNameController: viewModel.lastNameController,
                      lastNameValidator: checkText,
                      hasTitle: true,
                      hasLabel: false,
                    ),

                    const CustomSizedBox.hugeGap(),
                    AuthSubmitWidget(
                      label: LocaleKeys.auth_register.tr(),
                      voidCallBack: () async {
                        if (!(registerFormsKey.currentState?.validate() ??
                            true)) {
                          return;
                        }
                        await viewModel.registerUser(ref, context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

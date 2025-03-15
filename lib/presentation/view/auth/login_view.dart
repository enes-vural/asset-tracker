import 'package:asset_tracker/core/config/constants/global/key/fom_keys.dart';
import 'package:asset_tracker/core/config/constants/global/key/widget_keys.dart';
import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/core/widgets/custom_align.dart';
import 'package:asset_tracker/injection.dart';
import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import '../../view_model/auth/auth_view_model.dart';
import 'widget/auth_form_widget.dart';
import 'widget/auth_submit_widget.dart';

import '../../../core/config/theme/extension/app_size_extension.dart';
import '../../../core/config/theme/style_theme.dart';
import '../../../core/widgets/custom_padding.dart';
import '../widgets/circle_logo_widget.dart';

@RoutePage()
class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> with ValidatorMixin {
  @override
  Widget build(BuildContext context) {
    //bridge to viewModel :)
    final AuthViewModel authViewModel = ref.watch(authViewModelProvider);
    //
    return Scaffold(
      ///vanilla white background color by theme
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //bunu her sayfada yapmak yerine base stfull widget olusutrulabilir
      resizeToAvoidBottomInset: false,
      //appbar
      appBar: AppBar(title: _appBarTitleWidget()),
      //body
      // large a düzeltildi ekstra constructor içinde parametre verilmekten kaçınıldı
      body: CustomPadding.largeHorizontal(
        widget: Form(
          key: GlobalFormKeys.loginFormsKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _authLogoWidget(),
              _signInTextWidget(),
              AuthFormWidget.email(
                key: WidgetKeys.loginEmailTextFieldKey,
                emailController: authViewModel.emailController,
                emailValidator: checkEmail,
              ),
              AuthFormWidget.password(
                key: WidgetKeys.loginPasswordTextFieldKey,
                passwordController: authViewModel.passwordController,
                passwordValidator: checkPassword,
              ),
              _forgotPasswordWidget(),
              AuthSubmitWidget(
                key: WidgetKeys.loginSubmitButtonKey,
                label: LocaleKeys.auth_signIn.tr(),
                voidCallBack: () => _submit(authViewModel, context),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(AuthViewModel authViewModel, BuildContext context) {
    authViewModel.signInUser(ref, context);
  }

  Center _authLogoWidget() {
    return const Center(
      heightFactor: AppSize.defaultHeightFactor,
      child: CircleMainLogoWidget(
        key: WidgetKeys.loginAppLogoKey,
      ),
    );
  }

  Align _forgotPasswordWidget() {
    return CustomAlign.centerRight(
      child: TextButton(
          onPressed: () {},
          child: Text(
            LocaleKeys.auth_forgot.tr(),
            style: CustomTextStyle.blackColorPoppins(AppSize.smallText),
          )),
    );
  }

  Text _appBarTitleWidget() {
    return Text(
      LocaleKeys.app_title.tr(),
      style: CustomTextStyle.whiteColorPoppins(AppSize.largeText),
    );
  }

  Text _signInTextWidget() => Text(
      key: WidgetKeys.loginSignInTextKey,
      LocaleKeys.auth_signIn.tr(),
      style: CustomTextStyle.whiteColorPoppins(AppSize.mediumText));
}

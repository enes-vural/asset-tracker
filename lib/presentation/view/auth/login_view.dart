import 'dart:io';

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/constants/global/key/widget_keys.dart';
import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/core/widgets/custom_align.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_form_widget.dart';
import 'package:asset_tracker/presentation/view/auth/widget/half_login_button_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/parota_logo_widget.dart';
import 'package:asset_tracker/presentation/view_model/auth/auth_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TrialViewState();
}

class _TrialViewState extends ConsumerState<LoginView> with ValidatorMixin {
  FocusNode? _emailFocusNode;
  FocusNode? _passwordFocusNode;

  void _initializeFocusNodes() {
    _emailFocusNode ??= FocusNode();
    _passwordFocusNode ??= FocusNode();
  }

  void _disposeFocusNodes() {
    _emailFocusNode?.dispose();
    _emailFocusNode = null;
    _passwordFocusNode?.dispose();
    _passwordFocusNode = null;
  }

  @override
  void initState() {
    super.initState();
    _initializeFocusNodes();
  }

  @override
  void dispose() {
    _disposeFocusNodes();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthViewModel viewModel = ref.watch(authViewModelProvider);
    final GlobalKey<FormState> loginFormsKey = GlobalKey<FormState>();
    return PopScope(
      canPop: viewModel.canPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const PaRotaLogoWidget(),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: loginFormsKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  LocaleKeys.auth_loginTitle.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 22.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const CustomSizedBox.hugeGap(),
                CustomPadding.largeHorizontal(
                  widget: Text(
                    LocaleKeys.auth_loginDesc.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                  ),
                ),
                const CustomSizedBox.hugeGap(),
                CustomPadding.hugeHorizontal(
                  widget: AuthFormWidget.email(
                    key: WidgetKeys.loginEmailTextFieldKey,
                    emailController: viewModel.emailController,
                    emailValidator: checkEmail,
                    hasTitle: false,
                    hasLabel: true,
                    focusNode: _emailFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) =>
                        _passwordFocusNode?.requestFocus(),
                  ),
                ),
                CustomPadding.hugeHorizontal(
                  widget: AuthFormWidget.password(
                    key: WidgetKeys.loginPasswordTextFieldKey,
                    passwordController: viewModel.passwordController,
                    passwordValidator: checkPassword,
                    hasTitle: false,
                    hasLabel: true,
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) =>
                        _submitLoginForm(loginFormsKey, viewModel),
                  ),
                ),
                const CustomSizedBox.mediumGap(),
                CustomPadding.largeHorizontal(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        LocaleKeys.auth_loginSubtitle.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: AppSize.smallText,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1.5),
                      ),
                    ],
                  ),
                ),
                const CustomSizedBox.mediumGap(),
                CustomPadding.hugeHorizontal(
                  widget: Row(
                    children: [
                      HalfLoginButton(
                        label: LocaleKeys.auth_registerButton.tr(),
                        color: DefaultColorPalette.customGreyLightX,
                        textStyle: CustomTextStyle.loginButtonTextStyle(
                          context,
                          DefaultColorPalette.mainTextBlack,
                        ),
                        onPressed: () =>
                            _navigateToRegisterView(viewModel, context),
                      ),
                      const CustomSizedBox.smallWidth(),
                      HalfLoginButton(
                        label: LocaleKeys.auth_loginButton.tr(),
                        color: DefaultColorPalette.mainBlue,
                        textStyle: CustomTextStyle.loginButtonTextStyle(
                          context,
                          DefaultColorPalette.mainWhite,
                        ),
                        onPressed: () =>
                            _submitLoginForm(loginFormsKey, viewModel),
                      ),
                    ],
                  ),
                ),
                const CustomSizedBox.mediumGap(),
                // Divider with "OR" text
                CustomPadding.hugeHorizontal(
                  widget: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'VEYA', // You can add this to your locale keys
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: AppSize.smallText,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomSizedBox.mediumGap(),
                // Google Sign-In Button
                CustomPadding.hugeHorizontal(
                  widget: SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: OutlinedButton.icon(
                      onPressed: () => _signInWithGoogle(viewModel, context),
                      icon: Image.network(
                        'https://developers.google.com/identity/images/g-logo.png',
                        height: 20,
                        width: 20,
                      ),
                      label: Text(
                        LocaleKeys.auth_signInGoogle.tr(),
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: AppSize.mediumText,
                          fontWeight: FontWeight.w500,
                          color: DefaultColorPalette.mainTextBlack,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                const CustomSizedBox.mediumGap(),
                if (Platform.isIOS)
                  CustomPadding.hugeHorizontal(
                    widget: SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: OutlinedButton.icon(
                        onPressed: () => _signInWithApple(viewModel, context),
                        icon: Icon(
                          Icons.apple,
                          size: 20,
                          color: DefaultColorPalette.mainTextBlack,
                        ),
                        label: Text(
                          LocaleKeys.auth_signInApple.tr(),
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: AppSize.mediumText,
                            fontWeight: FontWeight.w500,
                            color: DefaultColorPalette.mainTextBlack,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          side:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                CustomAlign.centerRight(
                  child: CustomPadding.hugeHorizontal(
                      widget: TextButton(
                    onPressed: () {
                      viewModel.routeForgotPasswordView(context);
                    },
                    child: Text(
                      LocaleKeys.auth_forgot.tr(),
                      style: CustomTextStyle.greyColorManrope(
                          context, AppSize.smallText),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitLoginForm(loginFormsKey, viewModel) {
    if (!(loginFormsKey.currentState?.validate() ?? true)) {
      return;
    }
    _submit(viewModel, context);
  }

  void _navigateToRegisterView(
      AuthViewModel authViewModel, BuildContext context) {
    authViewModel.routeRegisterView(context);
  }

  void _submit(AuthViewModel authViewModel, BuildContext context) async {
    await authViewModel.signInUser(ref, context);
  }

  void _signInWithGoogle(
      AuthViewModel authViewModel, BuildContext context) async {
    await authViewModel.signInWithGoogle(context);
  }

  void _signInWithApple(
      AuthViewModel authViewModel, BuildContext context) async {
    await authViewModel.signInWithApple(context);
  }
}

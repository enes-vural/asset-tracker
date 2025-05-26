import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/constants/global/key/fom_keys.dart';
import 'package:asset_tracker/core/constants/global/key/widget_keys.dart';
import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_form_widget.dart';
import 'package:asset_tracker/presentation/view_model/auth/auth_view_model.dart';
import 'package:auto_route/auto_route.dart';
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
  @override
  void initState() {
    super.initState();
    // Any initialization logic can go here
  }

  @override
  Widget build(BuildContext context) {
    final AuthViewModel viewModel = ref.watch(authViewModelProvider);
    final GlobalKey<FormState> loginFormsKey = GlobalKey<FormState>();
    return PopScope(
      canPop: viewModel.canPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Welcome to your future',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(17, 20, 22, 1),
                    fontFamily: 'Manrope',
                    fontSize: 22.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1.7.sh),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Form(
          key: loginFormsKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const CustomSizedBox.hugeGap(),
              const CustomPadding.largeHorizontal(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Get access to the tools you need to invest, spend, and put your money in motion.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(17, 20, 22, 1),
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.5),
                    ),
                  ],
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
                ),
              ),
              CustomPadding.hugeHorizontal(
                widget: AuthFormWidget.password(
                  key: WidgetKeys.loginPasswordTextFieldKey,
                  passwordController: viewModel.passwordController,
                  passwordValidator: checkPassword,
                  hasTitle: false,
                  hasLabel: true,
                ),
              ),
              const CustomSizedBox.mediumGap(),
              CustomPadding.largeHorizontal(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "'By continuing, you agree to Finaks's Terms of Service and acknowledge that you have read its Privacy Policy. '",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: DefaultColorPalette.customGrey,
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
                      label: "Sign Up",
                      color: DefaultColorPalette.customGreyLightX,
                      textStyle: CustomTextStyle.loginButtonTextStyle(
                        DefaultColorPalette.mainTextBlack,
                      ),
                      onPressed: () =>
                          _navigateToRegisterView(viewModel, context),
                    ),
                    const CustomSizedBox.smallWidth(),
                    HalfLoginButton(
                      label: "Next",
                      color: DefaultColorPalette.mainBlue,
                      textStyle: CustomTextStyle.loginButtonTextStyle(
                        DefaultColorPalette.mainWhite,
                      ),
                      onPressed: () {
                        if (!(loginFormsKey.currentState?.validate() ?? true)) {
                          return;
                        }
                        _submit(viewModel, context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToRegisterView(
      AuthViewModel authViewModel, BuildContext context) {
    authViewModel.routeRegisterView(context);
  }

  void _submit(AuthViewModel authViewModel, BuildContext context) async {
    await authViewModel.signInUser(ref, context);
  }
}

class HalfLoginButton extends StatelessWidget {
  const HalfLoginButton({
    super.key,
    required this.label,
    required this.textStyle,
    required this.onPressed,
    required this.color,
  });

  final String label;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 48.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.mediumRadius),
            ),
            color: color,
          ),
          child: SizedBox(
            height: AppSize.mediumText.h,
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

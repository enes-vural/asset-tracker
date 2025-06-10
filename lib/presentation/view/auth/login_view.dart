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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const PaRotaLogoWidget(),
          centerTitle: true,
        ),
        body: Form(
          key: loginFormsKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Paranın Rotasını Sende',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: DefaultColorPalette.mainTextBlack,
                    fontFamily: 'Manrope',
                    fontSize: 22.sp,
                    letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const CustomSizedBox.hugeGap(),
              CustomPadding.largeHorizontal(
                widget: Text(
                  'Yatırımlarını canlı takip et, yatırım portföyünü yönet, kazançlarını artır.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: DefaultColorPalette.mainTextBlack,
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
                      "Devam ederek PaRota'nın gizlilik politikasını ve kullanım koşullarını kabul etmiş olursun.",
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
                      label: "Kayıt Ol",
                      color: DefaultColorPalette.customGreyLightX,
                      textStyle: CustomTextStyle.loginButtonTextStyle(
                        DefaultColorPalette.mainTextBlack,
                      ),
                      onPressed: () =>
                          _navigateToRegisterView(viewModel, context),
                    ),
                    const CustomSizedBox.smallWidth(),
                    HalfLoginButton(
                      label: "Devam Et",
                      color: DefaultColorPalette.mainBlue,
                      textStyle: CustomTextStyle.loginButtonTextStyle(
                        DefaultColorPalette.mainWhite,
                      ),
                      onPressed: () =>
                          _submitLoginForm(loginFormsKey, viewModel),
                    ),
                  ],
                ),
              ),
              const CustomSizedBox.mediumGap(),
              CustomAlign.centerRight(
                child: CustomPadding.hugeHorizontal(
                    widget: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Şifremi Unuttum",
                    style: CustomTextStyle.greyColorManrope(AppSize.smallText),
                  ),
                )),
              ),
            
            ],
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
}

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:asset_tracker/core/helpers/dialog_helper.dart';
import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_form_widget.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_submit_widget.dart';
import 'package:asset_tracker/presentation/view/home/widgets/parota_logo_widget.dart';
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
  FocusNode? _emailFocusNode;
  FocusNode? _passwordFocusNode;
  FocusNode? _firstNameFocusNode;
  FocusNode? _lastNameFocusNode;

  void _initalizeFocusNodes() {
    _emailFocusNode ??= FocusNode();
    _passwordFocusNode ??= FocusNode();
    _firstNameFocusNode ??= FocusNode();
    _lastNameFocusNode ??= FocusNode();
  }

  void _disposeFocusNodes() {
    _emailFocusNode?.dispose();
    _emailFocusNode = null;
    _passwordFocusNode?.dispose();
    _passwordFocusNode = null;
    _firstNameFocusNode?.dispose();
    _firstNameFocusNode = null;
    _lastNameFocusNode?.dispose();
    _lastNameFocusNode = null;
  }

  @override
  void initState() {
    _initalizeFocusNodes();
    super.initState();
  }

  @override
  void dispose() {
    _disposeFocusNodes();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> registerFormsKey = GlobalKey<FormState>();
    final viewModel = ref.watch(authViewModelProvider);

    EasyDialog.showDialogOnProcess(context, ref, authViewModelProvider);

    return PopScope(
      canPop: viewModel.canPop,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: true,
            elevation: 0,
            title: const PaRotaLogoWidget(),
          ),
          body: CustomPadding.smallHorizontal(
            widget: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: registerFormsKey,
                child: CustomPadding.largeAll(
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const CustomSizedBox.largeGap(),
                      const Text(
                        'Hesap Oluştur',
                        style: TextStyle(
                          color: Color.fromRGBO(17, 20, 22, 1),
                          fontFamily: 'Manrope',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.27,
                        ),
                      ),
                      Text(
                        "PaRota Hesabı oluşturmak için lütfen aşağıdaki bilgileri doldurun.",
                        style: CustomTextStyle.greyColorManrope(
                            AppSize.small2Text),
                      ),

                      const CustomSizedBox.smallGap(),

                      // Email Field
                      AuthFormWidget.email(
                        emailController: viewModel.emailController,
                        emailValidator: checkEmail,
                        hasTitle: true,
                        hasLabel: false,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) =>
                            _passwordFocusNode?.requestFocus(),
                      ),
                      const CustomSizedBox.smallGap(),
                      AuthFormWidget.password(
                        passwordController: viewModel.passwordController,
                        passwordValidator: checkPassword,
                        hasTitle: true,
                        hasLabel: false,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) =>
                            _firstNameFocusNode?.requestFocus(),
                      ),

                      const CustomSizedBox.smallGap(),
                      // Password Field
                      AuthFormWidget.firstName(
                        firstNameController: viewModel.firstNameController,
                        firstNameValidator: checkText,
                        hasTitle: true,
                        hasLabel: false,
                        focusNode: _firstNameFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) =>
                            _lastNameFocusNode?.requestFocus(),
                      ),

                      const CustomSizedBox.smallGap(),
                      // First Name Field
                      AuthFormWidget.lastName(
                        lastNameController: viewModel.lastNameController,
                        lastNameValidator: checkText,
                        hasTitle: true,
                        hasLabel: false,
                        focusNode: _lastNameFocusNode,
                      ),
                      const CustomSizedBox.hugeGap(),
                      AuthSubmitWidget(
                          label: LocaleKeys.auth_register.tr(),
                          voidCallBack: () => _submitRegisterEvent(
                                registerFormsKey,
                                viewModel,
                              )),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Future<void> _submitRegisterEvent(registerFormsKey, viewModel) async {
    if (!(registerFormsKey.currentState?.validate() ?? true)) {
      return;
    }
    await viewModel.registerUser(ref, context);
  }
}

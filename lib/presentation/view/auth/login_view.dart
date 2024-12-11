import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/widgets/custom_align.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import '../../../core/config/theme/style_theme.dart';
import 'widget/auth_form_widget.dart';
import 'widget/auth_submit_widget.dart';

import '../../../core/config/theme/extension/app_size_extension.dart';
import '../../../core/widgets/custom_padding.dart';
import '../widgets/circle_logo_widget.dart';

@RoutePage()
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      ///vanilla white background color by theme
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //appbar
      appBar: AppBar(title: _appBarTitleWidget()),
      //body
      // large a düzeltildi ekstra constructor içinde parametre verilmekten kaçınıldı
      body: CustomPadding.largeHorizontal(
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _authLogoWidget(size),
            signInTextWidget(),
            const AuthFormWidget.email(
              emailController: null,
              emailValidator: null,
            ),
            const AuthFormWidget.password(
              passwordController: null,
              passwordValidator: null,
            ),
            _forgotPasswordWidget(),
            const AuthSubmitWidget(
                label: DefaultLocalStrings.signInText, voidCallBack: null),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Center _authLogoWidget(Size size) {
    return const Center(
      heightFactor: AppSize.defaultHeightFactor,
      child: CircleMainLogoWidget(),
    );
  }

  Align _forgotPasswordWidget() {
    return CustomAlign.centerRight(
      widget: TextButton(
          onPressed: () {},
          child: Text(
            DefaultLocalStrings.forgotText,
            style: CustomTextStyle.blackColorPoppins(AppSize.smallText),
          )),
    );
  }

  Text _appBarTitleWidget() {
    return Text(
      DefaultLocalStrings.appTitle,
      style: CustomTextStyle.whiteColorPoppins(AppSize.largeText),
    );
  }

  Text signInTextWidget() =>
       Text(DefaultLocalStrings.signInText,
      style: CustomTextStyle.whiteColorPoppins(AppSize.mediumText));
}

import 'package:asset_tracker/core/widgets/custom_align.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'widget/auth_form_widget.dart';
import 'widget/auth_submit_widget.dart';

import '../../../core/config/theme/extension/app_size_extension.dart';
import '../../../core/config/theme/style_theme.dart';
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
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _authLogoWidget(),
            signInTextWidget(),
            AuthFormWidget.email(
              emailController: null,
              emailValidator: null,
            ),
            AuthFormWidget.password(
              passwordController: null,
              passwordValidator: null,
            ),
            _forgotPasswordWidget(),
            AuthSubmitWidget(
              label: LocaleKeys.auth_signIn.tr(),
              voidCallBack: null,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Center _authLogoWidget() {
    return const Center(
      heightFactor: AppSize.defaultHeightFactor,
      child: CircleMainLogoWidget(),
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

  Text signInTextWidget() =>
       Text(LocaleKeys.auth_signIn.tr(),
      style: CustomTextStyle.whiteColorPoppins(AppSize.mediumText));
}

import 'package:asset_tracker/core/widgets/custom_align.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/core/widgets/custom_sized_box.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_form_widget.dart';
import 'package:asset_tracker/presentation/view/auth/widget/auth_submit_widget.dart';
import 'package:asset_tracker/presentation/view/widgets/circle_logo_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Register"),
        ),
        body: CustomPadding.largeHorizontal(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CustomSizedBox.hugeGap(),
              const Center(child: CircleMainLogoWidget()),
              const CustomSizedBox.hugeGap(),
              const CustomAlign.centerLeft(
                  child: Text("Register your account into Asset Tracker")),
              AuthFormWidget.email(
                emailController: null,
                emailValidator: null,
              ),
              const CustomSizedBox.smallGap(),
              AuthFormWidget.password(
                passwordController: null,
                passwordValidator: null,
              ),
              const CustomSizedBox.hugeGap(),
              CustomAlign.centerRight(
                child: CheckboxMenuButton(
                    value: true,
                    onChanged: (newState) {},
                    child: const Text("Accept Terms & Conditions")),
              ),
              AuthSubmitWidget(
                label: "Register",
                voidCallBack: () {
                  debugPrint("Use Case will call here");
                },
              ),
            ],
          ),
        ));
  }
}

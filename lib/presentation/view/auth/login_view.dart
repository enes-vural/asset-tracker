import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/circle_logo_widget.dart';
import 'widget/auth_form_widget.dart';
import 'widget/auth_submit_widget.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(title: appBarTitleWidget()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            authLogoWidget(size),
            signInTextWidget(),
            AuthFormWidget(
                size: size,
                isObs: false,
                label: "Email",
                formController: null,
                validaor: null),
            AuthFormWidget(
                size: size,
                isObs: true,
                label: "Password",
                formController: null,
                validaor: null),
            forgotPasswordWidget(),
            AuthSubmitWidget(size: size, label: "Sign In", voidCallBack: null),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Center authLogoWidget(Size size) {
    return Center(
      heightFactor: 1.2,
      child: CircleLogoWidget(radius: size.width / 4.0),
    );
  }

  Align forgotPasswordWidget() {
    return Align(
      alignment: Alignment.centerRight,
      child:
          TextButton(onPressed: () {}, child: const Text("Forgot password ?")),
    );
  }

  Text appBarTitleWidget() {
    return Text(
      "Gold Exchance",
      style: GoogleFonts.poppins(color: Colors.white),
    );
  }

  Text signInTextWidget() =>
      const Text("Sign In", style: TextStyle(fontSize: 18.0));
}

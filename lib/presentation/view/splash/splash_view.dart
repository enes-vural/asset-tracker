import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/presentation/view/widgets/circle_logo_widget.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    //Automatically pushes to splash screen after 3 second.
    //The mounted avoids from lifecycle crash during wait.
    Future.delayed(const Duration(seconds: 3)).then((_) => mounted
        ? Routers.instance.pushReplaceNamed(context, Routers.loginPath)
        : null);
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery getter for responsive design.
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(child: CircleLogoWidget(radius: size.width / 4.0)),
    );
  }
}

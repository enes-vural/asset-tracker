// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:asset_tracker/core/config/constants/global/key/widget_keys.dart';
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
    //duration variable
    const int _splashDuration = 3;
    //Automatically pushes to splash screen after 3 second.
    //The mounted avoids from lifecycle crash during wait.
    Future.delayed(const Duration(seconds: _splashDuration)).then((_) => mounted
        ? Routers.instance.pushReplaceNamed(context, Routers.homePath)
        : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //dark blue for splash background color
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      //default body
      body: const Center(
          child: CircleMainLogoWidget(
        key: WidgetKeys.splashLogoKey,
      )),
    );
  }
}

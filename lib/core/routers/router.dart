import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/routers/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

class Routers {
  Routers._();

  static final Routers instance = Routers._();

  static const String splashPath = DefaultLocalStrings.splashRoute;
  static const String loginPath = DefaultLocalStrings.loginRoute;
  static const String homePath = DefaultLocalStrings.homeRoute;
  static const String tradePath = DefaultLocalStrings.tradeRoute;
  static const String dashboardPath = DefaultLocalStrings.dashboardRoute;
  static const String registerPath = DefaultLocalStrings.registerRoute;

  Route<T> _createSlideRoute<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Sağdan başlar
        const end = Offset.zero; // Merkeze kayar
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void pushReplaceNamed(BuildContext context, String routePath) {
    AutoRouter.of(context).pushNamed(routePath);
  }

  void pop(BuildContext context) {
    AutoRouter.of(context).popForced();
  }

  void popToSplash(BuildContext context) async {
    await AutoRouter.of(context).popAndPush(const SplashRoute());
  }

  void pushWithInfo<T>(BuildContext context, PageRouteInfo route) {
    AutoRouter.of(context).push(route);
  }
}

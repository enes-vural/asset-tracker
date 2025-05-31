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


  void pushNamed(BuildContext context, String routePath) {
    AutoRouter.of(context).pushNamed(routePath);
  }

  void replaceAll(BuildContext context, PageRouteInfo<dynamic> route) {
    AutoRouter.of(context).replaceAll([route]);
  }

  void pushReplaceNamed(BuildContext context, String routePath) {
    AutoRouter.of(context).replaceNamed(routePath);
  }

  void pushAndRemoveUntil(BuildContext context, PageRouteInfo<dynamic> route) {
    AutoRouter.of(context).pushAndPopUntil(
      route,
      predicate: (route) => false,
    );
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

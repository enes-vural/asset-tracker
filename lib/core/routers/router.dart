import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

class Routers {
  Routers._();

  static final Routers instance = Routers._();

  static const String splashPath = DefaultLocalStrings.splashRoute;
  static const String loginPath = DefaultLocalStrings.loginRoute;
  static const String homePath = DefaultLocalStrings.homeRoute;
  static const String tradePath = DefaultLocalStrings.tradeRoute;

  void pushReplaceNamed(BuildContext context, String routePath) {
    AutoRouter.of(context).pushNamed(routePath);
  }

  void pushWithInfo<T>(BuildContext context, PageRouteInfo route) {
    AutoRouter.of(context).push(route);
  }
}

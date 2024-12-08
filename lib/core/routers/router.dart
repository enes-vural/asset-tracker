import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

class Routers {
  Routers._();

  static final Routers instance = Routers._();

  static const String splashPath = "/default_splash";
  static const String loginPath = "/app_login";

  void pushReplaceNamed(BuildContext context, String routePath) {
    AutoRouter.of(context).pushNamed(routePath);
  }
}

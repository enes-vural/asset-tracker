import 'package:asset_tracker/core/routers/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // - Default (Splash View)
        AutoRoute(
          path: '/default_splash',
          page: SplashRoute.page,
          initial: true,
        ),
        // - Auth (Login View)
        AutoRoute(
          path: '/app_login',
          page: LoginRoute.page,
        ),
      ];
}

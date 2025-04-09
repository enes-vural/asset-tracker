import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/routers/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig(replaceInRouteName: DefaultLocalStrings.replaceInRouteName)
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // - Default (Splash View)
        AutoRoute(
          path: DefaultLocalStrings.splashRoute,
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: DefaultLocalStrings.tradeRoute,
          page: TradeRoute.page,
          //initial: true
        ),
        AutoRoute(
          path: DefaultLocalStrings.registerRoute,
          page: RegisterRoute.page,
        ),
        AutoRoute(
          path: DefaultLocalStrings.dashboardRoute,
          page: DashboardRoute.page,
        ),  
        // - Auth (Login View)
        AutoRoute(
          path: DefaultLocalStrings.loginRoute,
          page: LoginRoute.page,
        ),
        // - Home (Menu View)
        AutoRoute(
          path: DefaultLocalStrings.homeRoute,
          page: HomeRoute.page,
          //initial: true
        ),
      ];
}

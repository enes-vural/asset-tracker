import 'package:asset_tracker/core/constants/string_constant.dart';
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
        CustomRoute(
          path: DefaultLocalStrings.trialRoute,
          page: TrialRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
          //initial: true,
        ),
        CustomRoute(
          path: DefaultLocalStrings.tradeRoute,
          page: TradeRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
          //initial: true
        ),
        CustomRoute(
          path: DefaultLocalStrings.registerRoute,
          page: RegisterRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute(
          path: DefaultLocalStrings.dashboardRoute,
          page: DashboardRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),  
        // - Auth (Login View)
        CustomRoute(
          path: DefaultLocalStrings.loginRoute,
          page: LoginRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        // - Home (Menu View)
        CustomRoute(
          path: DefaultLocalStrings.homeRoute,
          page: HomeRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
          //initial: true
        ),
      ];
}

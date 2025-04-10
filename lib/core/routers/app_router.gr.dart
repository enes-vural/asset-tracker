// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:asset_tracker/presentation/view/auth/login_view.dart' as _i3;
import 'package:asset_tracker/presentation/view/home/dashboard/dashboard_view.dart'
    as _i1;
import 'package:asset_tracker/presentation/view/home/home_view.dart' as _i2;
import 'package:asset_tracker/presentation/view/home/trade/trade_view.dart'
    as _i5;
import 'package:asset_tracker/presentation/view/splash/splash_view.dart' as _i4;
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

/// generated route for
/// [_i1.DashboardView]
class DashboardRoute extends _i6.PageRouteInfo<void> {
  const DashboardRoute({List<_i6.PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.DashboardView();
    },
  );
}

/// generated route for
/// [_i2.HomeView]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeView();
    },
  );
}

/// generated route for
/// [_i3.LoginView]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginView();
    },
  );
}

/// generated route for
/// [_i4.SplashView]
class SplashRoute extends _i6.PageRouteInfo<void> {
  const SplashRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.SplashView();
    },
  );
}

/// generated route for
/// [_i5.TradeView]
class TradeRoute extends _i6.PageRouteInfo<TradeRouteArgs> {
  TradeRoute({
    _i7.Key? key,
    required String currecyCode,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          TradeRoute.name,
          args: TradeRouteArgs(
            key: key,
            currecyCode: currecyCode,
          ),
          rawPathParams: {'currency': currecyCode},
          initialChildren: children,
        );

  static const String name = 'TradeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TradeRouteArgs>(
          orElse: () =>
              TradeRouteArgs(currecyCode: pathParams.getString('currency')));
      return _i5.TradeView(
        key: args.key,
        currecyCode: args.currecyCode,
      );
    },
  );
}

class TradeRouteArgs {
  const TradeRouteArgs({
    this.key,
    required this.currecyCode,
  });

  final _i7.Key? key;

  final String currecyCode;

  @override
  String toString() {
    return 'TradeRouteArgs{key: $key, currecyCode: $currecyCode}';
  }
}

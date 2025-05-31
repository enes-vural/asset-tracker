// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:asset_tracker/presentation/view/auth/login_view.dart' as _i3;
import 'package:asset_tracker/presentation/view/auth/register_view.dart' as _i4;
import 'package:asset_tracker/presentation/view/home/dashboard/dashboard_view.dart'
    as _i1;
import 'package:asset_tracker/presentation/view/home/home_view.dart' as _i2;
import 'package:asset_tracker/presentation/view/home/trade/trade_view.dart'
    as _i6;
import 'package:asset_tracker/presentation/view/splash/splash_view.dart' as _i5;
import 'package:asset_tracker/presentation/view/trial.dart' as _i7;
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;

/// generated route for
/// [_i1.DashboardView]
class DashboardRoute extends _i8.PageRouteInfo<void> {
  const DashboardRoute({List<_i8.PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.DashboardView();
    },
  );
}

/// generated route for
/// [_i2.HomeView]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute({List<_i8.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeView();
    },
  );
}

/// generated route for
/// [_i3.LoginView]
class LoginRoute extends _i8.PageRouteInfo<void> {
  const LoginRoute({List<_i8.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.LoginView();
    },
  );
}

/// generated route for
/// [_i4.RegisterView]
class RegisterRoute extends _i8.PageRouteInfo<void> {
  const RegisterRoute({List<_i8.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.RegisterView();
    },
  );
}

/// generated route for
/// [_i5.SplashView]
class SplashRoute extends _i8.PageRouteInfo<void> {
  const SplashRoute({List<_i8.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.SplashView();
    },
  );
}

/// generated route for
/// [_i6.TradeView]
class TradeRoute extends _i8.PageRouteInfo<TradeRouteArgs> {
  TradeRoute({
    _i9.Key? key,
    required String currecyCode,
    required String? price,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          TradeRoute.name,
          args: TradeRouteArgs(
            key: key,
            currecyCode: currecyCode,
            price: price,
          ),
          rawPathParams: {
            'currency': currecyCode,
            'price': price,
          },
          initialChildren: children,
        );

  static const String name = 'TradeRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TradeRouteArgs>(
          orElse: () => TradeRouteArgs(
                currecyCode: pathParams.getString('currency'),
                price: pathParams.optString('price'),
              ));
      return _i6.TradeView(
        key: args.key,
        currecyCode: args.currecyCode,
        price: args.price,
      );
    },
  );
}

class TradeRouteArgs {
  const TradeRouteArgs({
    this.key,
    required this.currecyCode,
    required this.price,
  });

  final _i9.Key? key;

  final String currecyCode;

  final String? price;

  @override
  String toString() {
    return 'TradeRouteArgs{key: $key, currecyCode: $currecyCode, price: $price}';
  }
}

/// generated route for
/// [_i7.TrialView]
class TrialRoute extends _i8.PageRouteInfo<void> {
  const TrialRoute({List<_i8.PageRouteInfo>? children})
      : super(
          TrialRoute.name,
          initialChildren: children,
        );

  static const String name = 'TrialRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.TrialView();
    },
  );
}

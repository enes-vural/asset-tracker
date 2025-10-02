// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:asset_tracker/presentation/view/auth/forgot_password_view.dart'
    as _i3;
import 'package:asset_tracker/presentation/view/auth/login_view.dart' as _i5;
import 'package:asset_tracker/presentation/view/auth/register_view.dart' as _i7;
import 'package:asset_tracker/presentation/view/home/alarm/alarm_view.dart'
    as _i1;
import 'package:asset_tracker/presentation/view/home/dashboard/dashboard_view.dart'
    as _i2;
import 'package:asset_tracker/presentation/view/home/home_view.dart' as _i4;
import 'package:asset_tracker/presentation/view/home/menu_view.dart' as _i6;
import 'package:asset_tracker/presentation/view/home/settings/settings_view.dart'
    as _i8;
import 'package:asset_tracker/presentation/view/home/trade/trade_view.dart'
    as _i10;
import 'package:asset_tracker/presentation/view/optional/update_view.dart'
    as _i12;
import 'package:asset_tracker/presentation/view/splash/splash_view.dart' as _i9;
import 'package:asset_tracker/presentation/view/trial.dart' as _i11;
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i14;

/// generated route for
/// [_i1.AlarmView]
class AlarmRoute extends _i13.PageRouteInfo<void> {
  const AlarmRoute({List<_i13.PageRouteInfo>? children})
    : super(AlarmRoute.name, initialChildren: children);

  static const String name = 'AlarmRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i1.AlarmView();
    },
  );
}

/// generated route for
/// [_i2.DashboardView]
class DashboardRoute extends _i13.PageRouteInfo<void> {
  const DashboardRoute({List<_i13.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i2.DashboardView();
    },
  );
}

/// generated route for
/// [_i3.ForgotPasswordView]
class ForgotPasswordRoute extends _i13.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i13.PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i3.ForgotPasswordView();
    },
  );
}

/// generated route for
/// [_i4.HomeView]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute({List<_i13.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i4.HomeView();
    },
  );
}

/// generated route for
/// [_i5.LoginView]
class LoginRoute extends _i13.PageRouteInfo<void> {
  const LoginRoute({List<_i13.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i5.LoginView();
    },
  );
}

/// generated route for
/// [_i6.MenuView]
class MenuRoute extends _i13.PageRouteInfo<void> {
  const MenuRoute({List<_i13.PageRouteInfo>? children})
    : super(MenuRoute.name, initialChildren: children);

  static const String name = 'MenuRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i6.MenuView();
    },
  );
}

/// generated route for
/// [_i7.RegisterView]
class RegisterRoute extends _i13.PageRouteInfo<void> {
  const RegisterRoute({List<_i13.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i7.RegisterView();
    },
  );
}

/// generated route for
/// [_i8.SettingsView]
class SettingsRoute extends _i13.PageRouteInfo<void> {
  const SettingsRoute({List<_i13.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i8.SettingsView();
    },
  );
}

/// generated route for
/// [_i9.SplashView]
class SplashRoute extends _i13.PageRouteInfo<void> {
  const SplashRoute({List<_i13.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i9.SplashView();
    },
  );
}

/// generated route for
/// [_i10.TradeView]
class TradeRoute extends _i13.PageRouteInfo<TradeRouteArgs> {
  TradeRoute({
    _i14.Key? key,
    required String currencyCode,
    required String? price,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         TradeRoute.name,
         args: TradeRouteArgs(
           key: key,
           currencyCode: currencyCode,
           price: price,
         ),
         rawPathParams: {'currency': currencyCode, 'price': price},
         initialChildren: children,
       );

  static const String name = 'TradeRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TradeRouteArgs>(
        orElse: () => TradeRouteArgs(
          currencyCode: pathParams.getString('currency'),
          price: pathParams.optString('price'),
        ),
      );
      return _i10.TradeView(
        key: args.key,
        currencyCode: args.currencyCode,
        price: args.price,
      );
    },
  );
}

class TradeRouteArgs {
  const TradeRouteArgs({
    this.key,
    required this.currencyCode,
    required this.price,
  });

  final _i14.Key? key;

  final String currencyCode;

  final String? price;

  @override
  String toString() {
    return 'TradeRouteArgs{key: $key, currencyCode: $currencyCode, price: $price}';
  }
}

/// generated route for
/// [_i11.TrialView]
class TrialRoute extends _i13.PageRouteInfo<void> {
  const TrialRoute({List<_i13.PageRouteInfo>? children})
    : super(TrialRoute.name, initialChildren: children);

  static const String name = 'TrialRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i11.TrialView();
    },
  );
}

/// generated route for
/// [_i12.UpdateView]
class UpdateRoute extends _i13.PageRouteInfo<void> {
  const UpdateRoute({List<_i13.PageRouteInfo>? children})
    : super(UpdateRoute.name, initialChildren: children);

  static const String name = 'UpdateRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i12.UpdateView();
    },
  );
}

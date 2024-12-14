// ignore_for_file: overridden_fields, annotate_overrides

import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:flutter/material.dart';

class CustomPadding extends Padding {
  /// ALL --------------------

  ///all 8.0
  const CustomPadding.smallAll({super.key, required Widget widget})
      : super(padding: const CustomEdgeInstets.smallAll(), child: widget);

  ///all 12.0
  const CustomPadding.mediumAll({super.key, required Widget widget})
      : super(padding: const CustomEdgeInstets.mediumAll(), child: widget);

  ///all 16.0
  const CustomPadding.largeAll({super.key, required Widget widget})
      : super(padding: const CustomEdgeInstets.largeAll(), child: widget);

  /// all 24.0
  const CustomPadding.hugeAll({super.key, required Widget widget})
      : super(padding: const CustomEdgeInstets.hugeAll(), child: widget);

  /// ONLY TOP -----------------
  const CustomPadding.smallTop({super.key, required Widget widget})
      : super(padding: const CustomEdgeInstets.smallTop(), child: widget);

  ///top 12.0
  const CustomPadding.mediumTop({super.key, required Widget widget})
      : super(padding: const CustomEdgeInstets.mediumTop(), child: widget);

  ///top 16.0
  const CustomPadding.largeTop({super.key, required Widget widget})
      : super(padding: const CustomEdgeInstets.largeTop(), child: widget);

  /// top 24.0
  const CustomPadding.hugeTop({super.key, required Widget widget})
      : super(padding: const CustomEdgeInstets.hugeTop(), child: widget);

  /// HORIZONTAL -----------------

  /// 8.0
  const CustomPadding.smallHorizontal({super.key, required Widget widget})
      : super(
            padding: const CustomEdgeInstets.smallHorizontal(), child: widget);

  /// 12.0

  const CustomPadding.mediumHorizontal({super.key, required Widget widget})
      : super(
            padding: const CustomEdgeInstets.mediumHorizontal(), child: widget);

  /// 16.0

  const CustomPadding.largeHorizontal({super.key, required Widget widget})
      : super(
            padding: const CustomEdgeInstets.largeHorizontal(), child: widget);

  /// 24.0

  const CustomPadding.hugeHorizontal({super.key, required Widget widget})
      : super(padding: const CustomEdgeInstets.hugeHorizontal(), child: widget);
}

///Custom Edge Insets settings
class CustomEdgeInstets extends EdgeInsets {
  /// ALL  -----------

  /// 8.0 padding all
  const CustomEdgeInstets.smallAll() : super.all(AppSize.smallPadd);

  ///12.0 padding all
  const CustomEdgeInstets.mediumAll() : super.all(AppSize.mediumPadd);

  ///16.0 padding all
  const CustomEdgeInstets.largeAll() : super.all(AppSize.largePadd);

  ///24.0 padding all
  const CustomEdgeInstets.hugeAll() : super.all(AppSize.hugePadd);

  /// ONLY TOP -------

  const CustomEdgeInstets.smallTop() : super.only(top: AppSize.smallPadd);

  ///12.0 padding all
  const CustomEdgeInstets.mediumTop() : super.only(top: AppSize.mediumPadd);

  ///16.0 padding all
  const CustomEdgeInstets.largeTop() : super.only(top: AppSize.largePadd);

  ///24.0 padding all
  const CustomEdgeInstets.hugeTop() : super.only(top: AppSize.hugePadd);

  /// HORIZONTAL --------

  ///8.0 padding horizontal
  const CustomEdgeInstets.smallHorizontal()
      : super.symmetric(horizontal: AppSize.smallPadd);

  ///12.0 padding horizontal
  const CustomEdgeInstets.mediumHorizontal()
      : super.symmetric(horizontal: AppSize.mediumPadd);

  ///16.0 padding horizontal
  const CustomEdgeInstets.largeHorizontal()
      : super.symmetric(horizontal: AppSize.largePadd);

  ///24.0 padding horizontal
  const CustomEdgeInstets.hugeHorizontal()
      : super.symmetric(horizontal: AppSize.hugePadd);
}

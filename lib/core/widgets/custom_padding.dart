// ignore_for_file: overridden_fields, annotate_overrides

import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:flutter/material.dart';

class CustomPadding extends Padding {
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

  /// top 16.0
  const CustomPadding.largeTop({super.key, required Widget widget})
      : super(padding: const CustomEdgeInstets.largeTop(), child: widget);

  /// horizontal 16.0
  const CustomPadding.largeHorizontal({super.key, required Widget widget})
      : super(
            padding: const CustomEdgeInstets.largeHorizontal(), child: widget);
}

///Custom Edge Insets settings
class CustomEdgeInstets extends EdgeInsets {
  /// 8.0 padding all
  const CustomEdgeInstets.smallAll() : super.all(AppSize.smallPadd);

  ///12.0 padding all
  const CustomEdgeInstets.mediumAll() : super.all(AppSize.mediumPadd);

  ///16.0 padding all
  const CustomEdgeInstets.largeAll() : super.all(AppSize.largePadd);

  ///24.0 padding all
  const CustomEdgeInstets.hugeAll() : super.all(AppSize.hugePadd);

  ///16.0 padding top
  const CustomEdgeInstets.largeTop() : super.only(top: AppSize.largePadd);

  ///16.0 padding horizontal
  const CustomEdgeInstets.largeHorizontal()
      : super.symmetric(horizontal: AppSize.largePadd);
}

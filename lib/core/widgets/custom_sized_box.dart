import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:flutter/material.dart';

class CustomSizedBox extends SizedBox {
  const CustomSizedBox({super.key});

  const CustomSizedBox.empty({super.key}) : super();

  const CustomSizedBox.smallGap({super.key}) : super(height: AppSize.smallPadd);
  const CustomSizedBox.mediumGap({super.key})
      : super(height: AppSize.mediumPadd);
  const CustomSizedBox.largeGap({super.key}) : super(height: AppSize.largePadd);
  const CustomSizedBox.hugeGap({super.key}) : super(height: AppSize.hugePadd);

  const CustomSizedBox.smallWidth({super.key})
      : super(width: AppSize.smallPadd);
  const CustomSizedBox.mediumWidth({super.key})
      : super(width: AppSize.mediumPadd);
  const CustomSizedBox.largeWidth({super.key})
      : super(width: AppSize.largePadd);

  const CustomSizedBox.hugeWidth({super.key}) : super(width: AppSize.hugePadd);
}

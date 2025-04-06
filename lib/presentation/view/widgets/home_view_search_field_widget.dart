import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/extension/app_size_extension.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:asset_tracker/core/widgets/custom_icon.dart';
import 'package:asset_tracker/core/widgets/custom_padding.dart';
import 'package:asset_tracker/generated/locale_keys.g.dart';
import 'package:asset_tracker/presentation/view_model/home/home_view_model.dart';

class HomeViewSearchFieldWidget extends StatelessWidget {
  const HomeViewSearchFieldWidget({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveSize(context).screenSize.width.toHalf(),
      padding: const CustomEdgeInstets.largeHorizontal(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.hugeRadius),
        color: DefaultColorPalette.opacityWhite, // Hafif transparan beyaz
        boxShadow: [
          BoxShadow(
            color: DefaultColorPalette.opacityBlack,
            blurRadius: 10.0,
            offset: const Offset(0, 4), // Alt tarafa doğru gölge
          ),
        ],
      ),
      child: TextField(
        controller: viewModel.searchBarController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: LocaleKeys.home_search.tr(),
          hintStyle: TextStyle(color: DefaultColorPalette.grey600),
          prefixIcon: CustomIcon.searchIcon(),
        ),
      ),
    );
  }
}

import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/config/theme/app_size.dart';
import 'package:asset_tracker/core/config/theme/style_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.searchBarController,
    required this.onChangedFn,
  });

  final TextEditingController searchBarController;
  final ValueChanged<String>? onChangedFn;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: searchBarController,
        onChanged: onChangedFn,
        decoration: InputDecoration(
          fillColor: DefaultColorPalette.vanillaWhite,
          filled: true,
          suffixIcon: Icon(Icons.search, color: DefaultColorPalette.grey500),
          hintText: LocaleKeys.home_search.tr(),
          hintStyle:
              CustomTextStyle.blackColorPoppins(context, AppSize.mediumText),
          enabledBorder: _searchBorderStyle(),
          focusedBorder: _searchBorderStyle(),
        ));
  }

  OutlineInputBorder _searchBorderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.smallRadius),
      borderSide: const BorderSide(
        color: DefaultColorPalette.vanillaWhite,
        style: BorderStyle.solid,
      ),
    );
  }
}

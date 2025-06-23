import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSwitcherWidget extends StatelessWidget {
  const LanguageSwitcherWidget({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.language,
            color: Colors.green[600],
            size: 20,
          ),
        ),
        title: Text(
          LocaleKeys.home_settings_language.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          LocaleKeys.home_settings_languageDesc.tr(),
          style: TextStyle(fontSize: 14),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[100]
                : Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            LocalizationManager().getCurrentLanguageDisplay(context),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[700]
                  : Colors.white,
            ),
          ),
        ),
        onTap: () async {
          await LocalizationManager().changeLanguage(context);
        },
      ),
    );
  }
}

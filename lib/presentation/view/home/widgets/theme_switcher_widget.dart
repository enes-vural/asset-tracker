import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSwitcherWidget extends ConsumerWidget {
  const ThemeSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final contextTheme = Theme.of(context);
    final themeMode = theme.maybeWhen(
      data: (data) => data.currentTheme,
      orElse: () => ThemeMode.system,
    );

    final isDark = themeMode == ThemeMode.dark;
    final isLight = themeMode == ThemeMode.light;

    String subtitle;
    IconData icon;
    Color iconColor;

    if (isDark) {
      subtitle = LocaleKeys.home_settings_themeDark.tr();
      icon = Icons.dark_mode;
      iconColor = Colors.blueGrey;
    } else if (isLight) {
      subtitle = LocaleKeys.home_settings_themeLight.tr();
      icon = Icons.light_mode;
      iconColor = Colors.amber[800]!;
    } else {
      subtitle = LocaleKeys.home_settings_themeSystem.tr();
      icon = Icons.brightness_auto;
      iconColor = Colors.green[700]!;
    }

    return Material(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16.0),
        bottomRight: Radius.circular(16.0),
      ),
      clipBehavior: Clip.hardEdge,
      color: DefaultColorPalette.vanillaTranparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        title: Text(
          LocaleKeys.home_settings_theme.tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: contextTheme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: iconColor,
          ),
        ),
        onTap: () async {
          await ref.read(appThemeProvider.notifier).switchAppTheme();
        },
      ),
    );
  }
}

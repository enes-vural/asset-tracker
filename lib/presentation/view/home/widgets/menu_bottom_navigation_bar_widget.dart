import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuBottomNavigationBarWidget extends ConsumerWidget {
  const MenuBottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(appGlobalProvider).menuNavigationIndex;

    return Container(
      decoration: BoxDecoration(
        //color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(appGlobalProvider).changeMenuNavigationIndex(index),
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.white,
        selectedItemColor: DefaultColorPalette.mainBlue,
        unselectedItemColor: DefaultColorPalette.grey400,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: LocaleKeys.bottomNavBar_home.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            activeIcon: const Icon(Icons.account_balance_wallet),
            label: LocaleKeys.bottomNavBar_wallet.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.trending_down),
            activeIcon: const Icon(Icons.trending_up),
            label: LocaleKeys.bottomNavBar_trade.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.alarm_add_outlined),
            activeIcon: const Icon(Icons.alarm_on_sharp),
            label: "Alarm",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            activeIcon: const Icon(Icons.settings_suggest_rounded),
            label: LocaleKeys.bottomNavBar_settings.tr(),
          ),
          
        ],
      ),
    );
  }
}

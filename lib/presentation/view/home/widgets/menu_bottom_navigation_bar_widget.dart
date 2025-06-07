import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuBottomNavigationBarWidget extends ConsumerWidget {
  const MenuBottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(appGlobalProvider).menuNavigationIndex;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
        backgroundColor: Colors.white,
        selectedItemColor: DefaultColorPalette.mainBlue,
        unselectedItemColor: DefaultColorPalette.grey400,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Ana Sayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: "Cüzdan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_down),
            activeIcon: Icon(Icons.trending_up),
            label: "Al-Sat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            activeIcon: Icon(Icons.settings_suggest_rounded),
            label: "Ayarlar",
          ),
        ],
      ),
    );
  }
}

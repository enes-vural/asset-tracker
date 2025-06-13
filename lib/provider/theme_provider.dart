import 'package:asset_tracker/core/constants/enums/theme/app_theme_mode_enum.dart';
import 'package:asset_tracker/domain/entities/database/cache/app_theme_entity.dart';
import 'package:asset_tracker/domain/usecase/cache/cache_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppThemeState {
  final ThemeMode currentTheme;
  final bool isInitialized;

  const AppThemeState({
    required this.currentTheme,
    required this.isInitialized,
  });

  AppThemeState copyWith({
    ThemeMode? currentTheme,
    bool? isInitialized,
  }) {
    return AppThemeState(
      currentTheme: currentTheme ?? this.currentTheme,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  factory AppThemeState.initial() {
    return const AppThemeState(
      currentTheme: ThemeMode.system,
      isInitialized: false,
    );
  }
}

class AppThemeNotifier extends AsyncNotifier<AppThemeState> {
  final CacheUseCase cacheUseCase;
  AppThemeEntity? _currentThemeEntity;

  AppThemeNotifier({required this.cacheUseCase});

  @override
  Future<AppThemeState> build() async {
    // Async işlemleri burada yapabilirsiniz
    _currentThemeEntity = await cacheUseCase.getTheme();

    return AppThemeState(
      currentTheme: _themeConverter(_currentThemeEntity),
      isInitialized: true,
    );
  }

  Future<void> switchAppTheme() async {
    if (_currentThemeEntity == null) {
      await _loadTheme();
    }

    // Mevcut modun bir sonrakine geç
    if (_currentThemeEntity?.mode == AppThemeModeEnum.LIGHT) {
      _currentThemeEntity = const AppThemeEntity(mode: AppThemeModeEnum.DARK);
    } else {
      _currentThemeEntity = const AppThemeEntity(mode: AppThemeModeEnum.LIGHT);
    }

    // State'i güncelle - otomatik bildirim
    state = AsyncValue.data(
      AppThemeState(
        currentTheme: _themeConverter(_currentThemeEntity),
        isInitialized: true,
      ),
    );

    await cacheUseCase.saveTheme(_currentThemeEntity!);
    debugPrint("NEW THEME: ${_currentThemeEntity!.mode.toString()}");
  }

  /// Temayı yükler
  Future<void> _loadTheme() async {
    final newTheme = await cacheUseCase.getTheme();

    // State'i güncelle - otomatik bildirim
    state = AsyncValue.data(
      AppThemeState(
          currentTheme: _themeConverter(newTheme), isInitialized: true),
    );
  }

  /// Enum'dan ThemeMode'a dönüştürür
  ThemeMode _themeConverter(AppThemeEntity? entity) {
    switch (entity?.mode) {
      case AppThemeModeEnum.DARK:
        return ThemeMode.dark;
      case AppThemeModeEnum.LIGHT:
        return ThemeMode.light;
      case AppThemeModeEnum.SYSTEM:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }
}

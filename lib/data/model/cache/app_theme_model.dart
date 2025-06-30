import 'package:asset_tracker/core/constants/enums/theme/app_theme_mode_enum.dart';
import 'package:asset_tracker/domain/entities/database/cache/app_theme_entity.dart';

final class AppThemeModel {
  final AppThemeModeEnum themeMode;

  const AppThemeModel({required this.themeMode});

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.toString(),
    };
  }

  factory AppThemeModel.fromJson(Map<String, dynamic>? json) {
    return AppThemeModel(
        themeMode: _convertStringToAppThemeModeEnum(json?['themeMode']));
  }

  static AppThemeModeEnum _convertStringToAppThemeModeEnum(String value) {
    return AppThemeModeEnum.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => AppThemeModeEnum.SYSTEM, // Varsayılan değer
    );
  }

  factory AppThemeModel.fromEntity(AppThemeEntity entity) {
    return AppThemeModel(themeMode: entity.mode);
  }
}

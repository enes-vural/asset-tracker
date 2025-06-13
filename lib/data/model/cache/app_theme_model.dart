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
    return AppThemeModel(themeMode: _convertStringToEnum(json?['themeMode']));
  }

  static _convertStringToEnum(String data) {
    switch (data) {
      case "SYSTEM":
        return AppThemeModeEnum.SYSTEM;
      case "LIGHT":
        return AppThemeModeEnum.LIGHT;
      case "DARK":
        return AppThemeModeEnum.DARK;
      default:
        return AppThemeModeEnum.LIGHT;
    }
  }

  factory AppThemeModel.fromEntity(AppThemeEntity entity) {
    return AppThemeModel(themeMode: entity.mode);
  }
}

import 'package:asset_tracker/core/constants/enums/theme/app_theme_mode_enum.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/cache/app_theme_model.dart';

final class AppThemeEntity implements BaseEntity {
  final AppThemeModeEnum mode;

  const AppThemeEntity({required this.mode});

  factory AppThemeEntity.fromModel(AppThemeModel model) {
    return AppThemeEntity(mode: model.themeMode);
  }
  @override
  toModel() => AppThemeModel(themeMode: mode);
}

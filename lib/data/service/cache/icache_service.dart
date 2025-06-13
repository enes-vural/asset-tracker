import 'package:asset_tracker/data/model/cache/app_theme_model.dart';
import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';

abstract interface class ICacheService {
  Future<String?> saveOfflineAction<T>(
    OfflineActionsModel<T> model,
    Map<String, dynamic> Function(T) toJsonT,
  );

  List<OfflineActionsModel> getOfflineActions();

  Future<void> removeOfflineAction(String? key);

  Future<void> clearAllOfflineActions();

  Future<void> saveTheme(AppThemeModel model);

  Future<Map<String, dynamic>?> getTheme();
}

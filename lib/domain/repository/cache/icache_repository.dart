import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';
import 'package:asset_tracker/domain/entities/database/cache/app_theme_entity.dart';

abstract interface class ICacheRepository {
  Future<String?> saveOfflineAction<T extends BaseEntity>(
    OfflineActionType type,
    T requestEntity,
  );

  List<OfflineActionsModel> getOfflineActions();

  Future<void> removeOfflineAction(String? id);

  Future<void> clearAllOfflineActions();

  Future<void> saveThemeMode(AppThemeEntity entity);

  Future<AppThemeEntity> getThemeMode();

  Future<void> saveCustomOrder(List<String> order);

  Future<List<String>?> getCustomOrder();
}

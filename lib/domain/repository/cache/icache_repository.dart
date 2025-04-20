import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';

abstract interface class ICacheRepository {
  Future<String?> saveOfflineAction<T extends BaseEntity>(
    OfflineActionType type,
    T requestEntity,
  );

  List<OfflineActionsModel> getOfflineActions();

  Future<void> removeOfflineAction(String? id);

  Future<void> clearAllOfflineActions();
}

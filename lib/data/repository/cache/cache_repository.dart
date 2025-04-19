import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';
import 'package:asset_tracker/data/service/cache/hive_cache_service.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_login_entity.dart';

final class CacheRepository {
  //TODO implemente alacak
  final HiveCacheService _hiveCacheService;

  const CacheRepository(this._hiveCacheService);

  Future<void> saveOfflineAction<T>(
    OfflineActionType type,
    T requestEntity,
  ) async {
    final requestModel = _convertEntityModel(requestEntity);

    if (requestModel == null) {
      throw Exception("Invalid request entity");
    }

    final OfflineActionsModel offlineModel = OfflineActionsModel(
      type: type,
      status: OfflineActionStatus.PENDING,
      params: requestModel,
    );

    return await _hiveCacheService.saveOfflineAction(
      offlineModel,
      (model) => model.toJson(),
    );
  }

  Future<List<OfflineActionsModel>> getOfflineActions<T>() async {
    return await _hiveCacheService.getOfflineActions();
  }

  Future<void> removeOfflineAction(String id) async {
    await _hiveCacheService.removeOfflineAction(id);
  }

  Future<void> clearAllOfflineActions() async {
    await _hiveCacheService.clearAllOfflineActions();
  }

  dynamic _convertEntityModel(dynamic entity) {
    if (entity is UserLoginEntity) {
      return UserLoginModel.fromEntity(entity);
    }
    throw UnsupportedError('Unsupported entity type: ${entity.runtimeType}');
  }
}

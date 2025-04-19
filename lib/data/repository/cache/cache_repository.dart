import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';
import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';
import 'package:asset_tracker/data/service/cache/icache_service.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_login_entity.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_register_entity.dart';
import 'package:asset_tracker/domain/repository/cache/icache_repository.dart';

final class CacheRepository implements ICacheRepository {
  final ICacheService _hiveCacheService;

  const CacheRepository(this._hiveCacheService);

  @override
  Future<String?> saveOfflineAction<T>(
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

  @override
  List<OfflineActionsModel> getOfflineActions() {
    return _hiveCacheService.getOfflineActions();
  }

  @override
  Future<void> removeOfflineAction(String? id) async {
    await _hiveCacheService.removeOfflineAction(id);
  }

  @override
  Future<void> clearAllOfflineActions() async {
    await _hiveCacheService.clearAllOfflineActions();
  }

  dynamic _convertEntityModel(dynamic entity) {
    if (entity is UserLoginEntity) {
      return UserLoginModel.fromEntity(entity);
    } else if (entity is UserRegisterEntity) {
      UserRegisterModel.fromEntity(entity);
    }
    throw UnsupportedError('Unsupported entity type: ${entity.runtimeType}');
  }
}

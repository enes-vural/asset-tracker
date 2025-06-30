import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/core/constants/enums/theme/app_theme_mode_enum.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/cache/app_theme_model.dart';
import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';
import 'package:asset_tracker/data/service/cache/icache_service.dart';
import 'package:asset_tracker/domain/entities/database/cache/app_theme_entity.dart';
import 'package:asset_tracker/domain/repository/cache/icache_repository.dart';

final class CacheRepository implements ICacheRepository {
  final ICacheService _hiveCacheService;

  const CacheRepository(this._hiveCacheService);

  @override
  Future<String?> saveOfflineAction<T extends BaseEntity>(
    OfflineActionType type,
    T requestEntity,
  ) async {
    final requestModel = requestEntity.toModel();

    if (requestModel == null) {
      throw Exception("Invalid request entity");
    }

    final OfflineActionsModel offlineModel = OfflineActionsModel(
      //Burada id değerini repository de boş veriyoruz.
      //Service katmanında uygun index bulunup içine atanacaktır.
      id: DefaultLocalStrings.emptyText,
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
    List<OfflineActionsModel> rawActions =
        _hiveCacheService.getOfflineActions();
    List<OfflineActionsModel> convertedActions = [];

    for (var action in rawActions) {
      final convertedAction = action.copyWith(
        params: action.params.toEntity(),
      );
      convertedActions.add(convertedAction);
    }
    return convertedActions;
  }

  @override
  Future<void> removeOfflineAction(String? id) async {
    await _hiveCacheService.removeOfflineAction(id);
  }

  @override
  Future<void> clearAllOfflineActions() async {
    await _hiveCacheService.clearAllOfflineActions();
  }

  @override
  Future<AppThemeEntity> getThemeMode() async {
    final data = await _hiveCacheService.getTheme();
    if (data == null) {
      return const AppThemeEntity(mode: AppThemeModeEnum.SYSTEM);
    }
    return AppThemeEntity.fromModel(AppThemeModel.fromJson(data));
  }

  @override
  Future<void> saveThemeMode(AppThemeEntity entity) async {
    final AppThemeModel model = AppThemeModel.fromEntity(entity);
    return await _hiveCacheService.saveTheme(model);
  }

  @override
  Future<List<String>?> getCustomOrder() async {
    return await _hiveCacheService.getCustomOrder();
  }

  @override
  Future<void> saveCustomOrder(List<String> order) async {
    return await _hiveCacheService.saveCustomOrder(order);
  }
}

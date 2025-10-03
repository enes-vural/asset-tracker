import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';
import 'package:asset_tracker/domain/entities/database/cache/app_theme_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/repository/cache/icache_repository.dart';
import 'package:asset_tracker/domain/usecase/base/base_use_case.dart';
import 'package:dartz/dartz.dart';

class CacheUseCase<T extends BaseEntity>
    extends BaseFreeUseCase<void, Tuple2<OfflineActionType, T>> {
  final ICacheRepository cacheRepository;
  CacheUseCase({required this.cacheRepository});

  @override
  Future<void> call(Tuple2<OfflineActionType, T> params) async {
    throw UnimplementedError();
  }

  Future<List<CurrencyEntity>?> getCachedCurrencyList() async {
    return await cacheRepository.getCachedCurrencyList();
  }

  Future<String?> saveOfflineAction(Tuple2<OfflineActionType, T> params) async {
    return await cacheRepository.saveOfflineAction(
        params.value1, params.value2);
  }

  List<OfflineActionsModel> getOfflineActions() {
    return cacheRepository.getOfflineActions();
  }

  Future<void> removeOfflineAction(String? id) async {
    return await cacheRepository.removeOfflineAction(id);
  }

  Future<void> clearAllOfflineActions() async {
    return await cacheRepository.clearAllOfflineActions();
  }

  Future<void> saveTheme(AppThemeEntity entity) async {
    return await cacheRepository.saveThemeMode(entity);
  }

  Future<AppThemeEntity> getTheme() async {
    return await cacheRepository.getThemeMode();
  }

  Future<void> saveCustomOrder(List<String> order) async {
    return await cacheRepository.saveCustomOrder(order);
  }

  Future<List<String>?> getCustomOrder() async {
    return await cacheRepository.getCustomOrder();
  }
}

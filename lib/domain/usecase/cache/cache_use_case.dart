import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/data/model/base/base_model.dart';
import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';
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
}

import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';
import 'package:asset_tracker/data/service/cache/icache_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

enum OfflineActionStatus {
  PENDING,
  BACKGROUND,
}

enum OfflineActionType {
  LOGIN,
  REGISTER,
  BUY_ASSET,
  SELL_ASSET,
}

final class HiveCacheService implements ICacheService {
  late final Box _box;

  static final HiveCacheService _instance = HiveCacheService._internal();
  static HiveCacheService get instance => _instance;
  static const String _boxName = "offline_actions";

  HiveCacheService._internal();

  factory HiveCacheService() {
    return _instance;
  }

  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    _box = await Hive.openBox(_boxName);
  }

  Future<void> clearAllOfflineActions() async {
    await _box.clear();
    debugPrint("Cleared all offline actions");
  }

  /// This method is used to get the next index for the offline action
  /// by checking the existing keys in the Hive box.
  int _getNextIndex(Box box) {
    final keys = box.keys
        .where((key) => key.toString().startsWith('offline_actions-'))
        .map((key) => int.tryParse(key.toString().split('-').last) ?? -1)
        .toList();

    if (keys.isEmpty) return 0;
    return (keys..sort()).last + 1;
  }

  /// This method is used to save an offline action to the Hive box.
  /// It takes a model of type [OfflineActionsModel<T>] and a function
  /// to convert the model to JSON.
  Future<void> saveOfflineAction<T>(
    OfflineActionsModel<T> model,
    Map<String, dynamic> Function(T) toJsonT,
  ) async {
    final box = await Hive.openBox(_boxName);
    final index = _getNextIndex(box);
    await box.put("offline_actions-$index", model.toJson(toJsonT));
    debugPrint("Saved action");
  }

  Future<void> removeOfflineAction(String key) async {
    await _box.delete(key);
    debugPrint("Deleted action with key: $key");
  }

  /// This method is used to get all offline actions from the Hive box.
  /// It takes a function to convert JSON to the model type [T].
  /// It returns a list of [OfflineActionsModel<T>].
  List<OfflineActionsModel> getOfflineActions() {
    final List<OfflineActionsModel> actions = [];

    for (var key in _box.keys) {
      if (key.toString().startsWith('offline_actions')) {
        final map = _box.get(key);
        if (map != null) {
          actions.add(OfflineActionsModel.fromJson(map));
        }
      }
    }

    return actions;
  }
}

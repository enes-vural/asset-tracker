import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';
import 'package:asset_tracker/data/service/cache/icache_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
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
  @override
  Future<String?> saveOfflineAction<T>(
    OfflineActionsModel<T> model,
    Map<String, dynamic> Function(T) toJsonT,
  ) async {
    final box = await Hive.openBox(_boxName);
    final index = _getNextIndex(box);
    final key = "offline_actions-$index"; // key'i belirliyoruz
    model = model.copyWith(id: key); // modelin id'sini güncelliyoruz

    await box.put(key, model.toJson(toJsonT));
    debugPrint("Saved action");
    return key;
  }

  @override
  Future<void> removeOfflineAction(String? key) async {
    if (key == null) {
      return;
    }
    await _box.delete(key);
    debugPrint("Deleted action with key: $key");
  }

  /// This method is used to get all offline actions from the Hive box.
  /// It takes a function to convert JSON to the model type [T].
  /// It returns a list of [OfflineActionsModel<T>].
  @override
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
    _printOfflineActions(actions);

    return _removeDuplicateActions(actions);
  }

  _printOfflineActions(List<OfflineActionsModel> actions) {
    for (OfflineActionsModel action in actions) {
      debugPrint(DefaultLocalStrings.dividerText);
      debugPrint("Action ID: ${action.id}");
      debugPrint("Action Type: ${action.type}");
      debugPrint("Action Status: ${action.status}");
      debugPrint("Action Params: ${action.params}");
      debugPrint(DefaultLocalStrings.dividerText);
    }
  }

  List<OfflineActionsModel> _removeDuplicateActions(
      List<OfflineActionsModel> actions) {
    List<OfflineActionsModel> uniqueActions = [];
    List<String> toDelete = [];
    final Set<String> seenTypes = {};

    uniqueActions = actions.where((action) {
      // Eğer aksiyon LOGIN türündeyse, sadece bir kez kabul et
      if (action.type == OfflineActionType.LOGIN) {
        // LOGIN için sadece ilkini kabul et
        if (seenTypes.contains(action.type.name)) {
          seenTypes.add(action.type.name);
          toDelete.add(action.id);
          debugPrint("Duplicate action found: ${action.id}");
          return false;
        } else {
          seenTypes.add(action.type.name);
          return true;
        }
      }

      String actionIdentifier = '${action.type}-${action.params.hashCode}';

      if (seenTypes.contains(actionIdentifier)) {
        toDelete.add(action.id);
        debugPrint("Duplicate action found: ${action.id}");
        return false;
      } else {
        seenTypes.add(actionIdentifier);
        return true;
      }
    }).toList();

    for (String id in toDelete) {
      removeOfflineAction(id);
    }
    return uniqueActions;
  }
}

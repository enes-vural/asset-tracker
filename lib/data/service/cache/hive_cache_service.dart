// ignore_for_file: unused_field

import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/data/model/cache/app_theme_model.dart';
import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';
import 'package:asset_tracker/data/model/web/currency_model.dart';
import 'package:asset_tracker/data/service/cache/icache_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final class HiveCacheService implements ICacheService {
  late final Box _offlineActionsBox;
  late final Box _themeBox;
  late final Box _customOrderBox;

  static final HiveCacheService _instance = HiveCacheService._internal();
  static HiveCacheService get instance => _instance;
  static const String _offlineActionsName = "offline_actions";
  static const String _themeName = "theme_box";
  static const String _customOrderKey = 'currency_custom_order_box';

  final List<String> _defaultOrder = [
    "USDTRY",
    "EURTRY",
    "KULCEALTIN",
    "CEYREK_YENI",
    "CEYREK_ESKI",
    "GBPTRY",
    "ALTIN",
    "AYAR22",
    "AYAR14",
    "ATA5_YENI",
    "ATA5_ESKI",
    "ATA_YENI",
    "ATA_ESKI",
    "GREMESE_YENI",
    "GREMESE_ESKI",
    "CHFTRY",
    "CADTRY",
    "AUDTRY",
    "DKKTRY",
  ];

  HiveCacheService._internal();

  factory HiveCacheService() {
    return _instance;
  }

  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    _offlineActionsBox = await Hive.openBox(_offlineActionsName);
    _themeBox = await Hive.openBox(_themeName);
    _customOrderBox = await Hive.openBox(_customOrderKey);
  }

  @override
  Future<void> clearAllOfflineActions() async {
    await _offlineActionsBox.clear();
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
    final box = await Hive.openBox(_offlineActionsName);
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
    await _offlineActionsBox.delete(key);
    debugPrint("Deleted action with key: $key");
  }

  /// This method is used to get all offline actions from the Hive box.
  /// It takes a function to convert JSON to the model type [T].
  /// It returns a list of [OfflineActionsModel<T>].
  @override
  List<OfflineActionsModel> getOfflineActions() {
    final List<OfflineActionsModel> actions = [];

    for (var key in _offlineActionsBox.keys) {
      if (key.toString().startsWith('offline_actions')) {
        final map = _offlineActionsBox.get(key);
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

  @override
  Future<Map<String, dynamic>?> getTheme() async {
    final box = await Hive.openBox(_themeName);
    final jsonData = await box.get("app_theme_key");
    if (jsonData == null) {
      return null;
    }
    return Map<String, dynamic>.from(jsonData);
  }

  @override
  Future<void> saveCurrencyList(List<CurrencyModel> assetList) async {
    final box = await Hive.openBox("currency_list_box");
    final List<Map<String, dynamic>> jsonList =
        assetList.map((asset) => asset.toJson()).toList();
    await box.put("currency_list_key", jsonList);
    debugPrint("Saved Currency List with ${jsonList.length} items");
    return;
  }

  @override
  Future<List<CurrencyModel>?> getCurrencyList() async {
    final box = await Hive.openBox("currency_list_box");
    final List<dynamic>? jsonData = await box.get("currency_list_key");
    if (jsonData == null) {
      return null;
    }
    final List<CurrencyModel> assetList = jsonData
        .map((item) => CurrencyModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    return assetList;
  }

  @override
  Future<void> saveTheme(AppThemeModel model) async {
    final box = await Hive.openBox(_themeName);
    await box.put("app_theme_key", model.toJson());
    debugPrint("Saved Theme Mode : ${model.themeMode.toString()}");
    return;
  }

  @override
  Future<void> saveCustomOrder(List<String> order) async {
    await _customOrderBox.put("currency_custom_order", order);
    return;
  }

  @override
  Future<List<String>?> getCustomOrder() async {
    return await _customOrderBox.get("currency_custom_order") ?? _defaultOrder;
  }
}

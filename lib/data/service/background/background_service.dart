import 'package:asset_tracker/data/service/cache/hive_cache_service.dart';
import 'package:asset_tracker/firebase_options.dart';
import 'package:asset_tracker/injection.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class BackgroundService {
  final List<String> _registeredTasks = [];
  static BackgroundService? _instance;
  static BackgroundService get instance {
    _instance ??= BackgroundService._();
    return _instance!;
  }

  BackgroundService._();

  Future init() async {
    await _configure();
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  Future _configure() async {
    Future<int> status = BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 20,
          forceAlarmManager: false,
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE),
      _onBackgroundReceived,
      _onBackgroundTimeout,
    );

    debugPrint("[BackgroundFetch] configure state: $status");
  }

  void _onBackgroundReceived(String taskId) async {
    debugPrint("Executing task on background: $taskId");
    // Burada yapman gereken işlemleri gerçekleştirebilirsin.
    if (taskId == 'com.transistorsoft.customtask') {
      // işlemler
      debugPrint("TASK GELDI OLEY");
    }
    BackgroundFetch.finish(taskId);
  }

  void _onBackgroundTimeout(String taskId) async {
    debugPrint("[BackgroundFetch] Task timeout: $taskId");
    BackgroundFetch.finish(taskId);
  }

  // Task eklemek için bir fonksiyon
  void addNewHeadlessTask(String taskId) {
    if (!_registeredTasks.contains(taskId)) {
      _registeredTasks.add(taskId);
      BackgroundFetch.scheduleTask(TaskConfig(
        taskId: taskId,
        //1200000 (20 minute)
        stopOnTerminate: false,
        //60000 (1 minute)
        delay: 1200000,
        periodic: true, //false for testing
        enableHeadless: true,
      ));
      debugPrint("[BackgroundService] Task scheduled: $taskId");
    }
  }

  // Taskları kaldırmak için bir fonksiyon
  void removeHeadlessTask(String taskId) {
    if (_registeredTasks.contains(taskId)) {
      _registeredTasks.remove(taskId);
      debugPrint("[BackgroundService] Task removed: $taskId");
    }
  }
}

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;

  if (isTimeout) {
    BackgroundFetch.finish(taskId);
    return;
  }

  if (task.taskId == 'com.transistorsoft.customtask') {
    debugPrint("[HeadlessTask] Background task executed: $taskId");
    debugPrint("WE HAD TASK IN BACKGROUND OLLLL");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    HiveCacheService hiveCacheService = HiveCacheService();
    await hiveCacheService.init();
    final backgroundContainer = ProviderContainer();
    final syncManager = backgroundContainer.read(syncManagerProvider);
    await syncManager.syncOfflineActionHeadless();
    backgroundContainer.dispose();

    // Burada yapman gereken işlemleri gerçekleştirebilirsin.
    // Örneğin, bir API çağrısı yapabilir veya veritabanına veri ekleyebilirsin.
  } else {
    debugPrint("[HeadlessTask111] Unknown task: $taskId");
  }

  debugPrint("[HeadlessTask111] Background task executed: $taskId");
}

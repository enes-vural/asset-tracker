import 'dart:io';

import 'package:asset_tracker/core/constants/global/general_constants.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/data/service/cache/hive_cache_service.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:asset_tracker/firebase_options.dart';
import 'package:asset_tracker/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

final String periodicTaskId = "com.sakasstudio.parota.mytask";



final class BackgroundService {
  final List<String> _registeredTasks = [];
  static BackgroundService? _instance;
  static BackgroundService get instance {
    _instance ??= BackgroundService._();
    return _instance!;
  }

  final String periodicTaskId = "com.sakasstudio.parota.mytask";

  BackgroundService._();

  Future init() async {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true, // Debug modda logları gör
    );

    Workmanager().registerPeriodicTask(
      periodicTaskId,
      periodicTaskId,
      
      frequency: const Duration(minutes: 20),
      // constraints: Constraints(
      //   networkType: NetworkType.connected,
      //   requiresBatteryNotLow: true,
      //   requiresCharging: false,
      // ),
    );

    print("Work Manager initialized");

    // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  // Future _configure() async {
  //   Future<int> status = BackgroundFetch.configure(
  //     BackgroundFetchConfig(
  //         minimumFetchInterval: 20,
  //         forceAlarmManager: false,
  //         stopOnTerminate: false,
  //         startOnBoot: true,
  //         enableHeadless: true,
  //         requiresBatteryNotLow: false,
  //         requiresCharging: false,
  //         requiresStorageNotLow: false,
  //         requiresDeviceIdle: false,
  //         requiredNetworkType: NetworkType.NONE),
  //     _onBackgroundReceived,
  //     _onBackgroundTimeout,
  //   );

  //   debugPrint("[BackgroundFetch] configure state: $status");
  // }

  // void _onBackgroundReceived(String taskId) async {
  //   debugPrint("Executing task on background: $taskId");
  //   // Burada yapman gereken işlemleri gerçekleştirebilirsin.
  //   if (taskId == 'com.transistorsoft.customtask') {
  //     // işlemler
  //     debugPrint("TASK GELDI OLEY");
  //   }
  //   BackgroundFetch.finish(taskId);
  // }

  // void _onBackgroundTimeout(String taskId) async {
  //   debugPrint("[BackgroundFetch] Task timeout: $taskId");
  //   BackgroundFetch.finish(taskId);
  // }

  // Task eklemek için bir fonksiyon
//   void addNewHeadlessTask(String taskId) {
//     if (!_registeredTasks.contains(taskId)) {
//       _registeredTasks.add(taskId);
//       BackgroundFetch.scheduleTask(TaskConfig(
//         taskId: taskId,
//         //1200000 (20 minute)
//         stopOnTerminate: false,
//         //60000 (1 minute)
//         delay: 1200000, //60000, //1200000,
//         periodic: true, //false for testing
//         enableHeadless: true,
//       ));
//       debugPrint("[BackgroundService] Task scheduled: $taskId");
//     }
//   }

//   // Taskları kaldırmak için bir fonksiyon
//   void removeHeadlessTask(String taskId) {
//     if (_registeredTasks.contains(taskId)) {
//       _registeredTasks.remove(taskId);
//       debugPrint("[BackgroundService] Task removed: $taskId");
//     }
//   }
// }

// @pragma('vm:entry-point')
// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   String taskId = task.taskId;
//   bool isTimeout = task.timeout;

//   if (isTimeout) {
//     BackgroundFetch.finish(taskId);
//     return;
//   }

//   if (task.taskId == 'com.transistorsoft.customtask') {
//     debugPrint("[HeadlessTask] Background task executed: $taskId");
//     debugPrint("WE HAD TASK IN BACKGROUND OLLLL");

//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );

//     setupDependencies();

//     HiveCacheService hiveCacheService = HiveCacheService();
//     await hiveCacheService.init();

//     final backgroundContainer = ProviderContainer();

//     // Mevcut sync işlemi
//     final syncManager = backgroundContainer.read(syncManagerProvider);
//     await syncManager.syncOfflineActionHeadless();

//     if (!getIt.isRegistered<GetSocketStreamUseCase>()) {
//       setupDependencies(); // Dependency'leri tekrar register et
//     }

//     // WebSocket bağlantısı kur ve widget'ı güncelle
//     try {
//       final socketUseCase = getIt<GetSocketStreamUseCase>();

//       // WebSocket'e bağlan
//       final connectionResult = await socketUseCase.call(null);

//       connectionResult.fold(
//         (error) {
//           debugPrint("[HeadlessTask] WebSocket bağlantı hatası: $error");
//         },
//         (success) async {
//           debugPrint("[HeadlessTask] WebSocket bağlantısı başarılı");

//           // Stream'i dinle
//           final dataStream = socketUseCase.getDataStream();

//           if (dataStream != null) {
//             // İlk veriyi al (timeout ile)
//             await dataStream
//                 .timeout(
//                   Duration(seconds: 15),
//                   onTimeout: (sink) {
//                     debugPrint("[HeadlessTask] WebSocket timeout");
//                     sink.close();
//                   },
//                 )
//                 .first
//                 .then((data) async {
//                   debugPrint("[HeadlessTask] WebSocket'ten veri alındı");

//                   // Veriyi parse et ve global state'e kaydet
//                   // (Burada senin parse mantığın ne ise onu kullan)
//                   if (data != null) {
//                     // Global assets'i güncelle
//                     // backgroundContainer.read(appGlobalProvider.notifier).updateAssets(parsedData);

//                     // Widget'ı güncelle
//                     await _updateHomeWidgetFromBackground(data);
//                   }
//                 })
//                 .catchError((error) {
//                   debugPrint("[HeadlessTask] Stream hatası: $error");
//                 });
//           }

//           // Bağlantıyı kapat
//           await socketUseCase.closeSocket();
//         },
//       );
//     } catch (e) {
//       debugPrint("[HeadlessTask] Widget güncelleme hatası: $e");
//     }

//     backgroundContainer.dispose();
//   } else {
//     debugPrint("[HeadlessTask111] Unknown task: $taskId");
//   }

//   debugPrint("[HeadlessTask111] Background task executed: $taskId");
//   BackgroundFetch.finish(taskId);
// }

// Yardımcı fonksiyon - WebSocket verisinden widget'ı güncelle
}




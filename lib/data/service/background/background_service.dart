import 'dart:io';

import 'package:asset_tracker/core/constants/global/general_constants.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/data/service/cache/hive_cache_service.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:asset_tracker/firebase_options.dart';
import 'package:asset_tracker/injection.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        delay: 1200000, //60000, //1200000,
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

    setupDependencies();

    HiveCacheService hiveCacheService = HiveCacheService();
    await hiveCacheService.init();

    final backgroundContainer = ProviderContainer();

    // Mevcut sync işlemi
    final syncManager = backgroundContainer.read(syncManagerProvider);
    await syncManager.syncOfflineActionHeadless();

    if (!getIt.isRegistered<GetSocketStreamUseCase>()) {
      setupDependencies(); // Dependency'leri tekrar register et
    }

    // WebSocket bağlantısı kur ve widget'ı güncelle
    try {
      final socketUseCase = getIt<GetSocketStreamUseCase>();

      // WebSocket'e bağlan
      final connectionResult = await socketUseCase.call(null);

      connectionResult.fold(
        (error) {
          debugPrint("[HeadlessTask] WebSocket bağlantı hatası: $error");
        },
        (success) async {
          debugPrint("[HeadlessTask] WebSocket bağlantısı başarılı");

          // Stream'i dinle
          final dataStream = socketUseCase.getDataStream();

          if (dataStream != null) {
            // İlk veriyi al (timeout ile)
            await dataStream
                .timeout(
                  Duration(seconds: 15),
                  onTimeout: (sink) {
                    debugPrint("[HeadlessTask] WebSocket timeout");
                    sink.close();
                  },
                )
                .first
                .then((data) async {
                  debugPrint("[HeadlessTask] WebSocket'ten veri alındı");

                  // Veriyi parse et ve global state'e kaydet
                  // (Burada senin parse mantığın ne ise onu kullan)
                  if (data != null) {
                    // Global assets'i güncelle
                    // backgroundContainer.read(appGlobalProvider.notifier).updateAssets(parsedData);

                    // Widget'ı güncelle
                    await _updateHomeWidgetFromBackground(data);
                  }
                })
                .catchError((error) {
                  debugPrint("[HeadlessTask] Stream hatası: $error");
                });
          }

          // Bağlantıyı kapat
          await socketUseCase.closeSocket();
        },
      );
    } catch (e) {
      debugPrint("[HeadlessTask] Widget güncelleme hatası: $e");
    }

    backgroundContainer.dispose();
  } else {
    debugPrint("[HeadlessTask111] Unknown task: $taskId");
  }

  debugPrint("[HeadlessTask111] Background task executed: $taskId");
  BackgroundFetch.finish(taskId);
}

// Yardımcı fonksiyon - WebSocket verisinden widget'ı güncelle
Future<void> _updateHomeWidgetFromBackground(
    List<CurrencyEntity> socketData) async {
  try {
    List<CurrencyEntity> priceData = socketData;

    debugPrint("[HeadlessTask] Updating widget with data:");
    debugPrint(socketData.toString());

    // Platform kontrolü
    final isAndroid = Platform.isAndroid;
    final isIOS = Platform.isIOS;

    // Android için SharedPreferences
    SharedPreferences? prefs;
    if (isAndroid) {
      prefs = await SharedPreferences.getInstance();
    }

    // GRAM ALTIN (KULCEALTIN)
    CurrencyEntity gramGold = priceData.firstWhere(
        (element) => element.code == 'KULCEALTIN',
        orElse: () => CurrencyEntity.empty());

    if (gramGold.code != DefaultLocalStrings.emptyText) {
      final gramAltinBuy = gramGold.alis.toString();
      final gramAltinSell = gramGold.satis.toString();
      final gramAltinChange = gramGold.fark.toString();

      if (isIOS) {
        await HomeWidget.saveWidgetData('gramAltin_buy', gramAltinBuy);
        await HomeWidget.saveWidgetData('gramAltin_sell', gramAltinSell);
        await HomeWidget.saveWidgetData('gramAltin_change', gramAltinChange);
      } else if (isAndroid) {
        await prefs?.setString('flutter.gramAltin_buy', gramAltinBuy);
        await prefs?.setString('flutter.gramAltin_sell', gramAltinSell);
        await prefs?.setString('flutter.gramAltin_change', gramAltinChange);
      }
    }

    // DOLAR (USDTRY)

    CurrencyEntity dolar = priceData.firstWhere(
        (element) => element.code == 'USDTRY',
        orElse: () => CurrencyEntity.empty());

    if (dolar.code != DefaultLocalStrings.emptyText) {
      final dolarBuy = dolar.alis.toString();
      final dolarSell = dolar.satis.toString();
      final dolarChange = dolar.fark.toString();

      if (isIOS) {
        await HomeWidget.saveWidgetData('dolar_buy', dolarBuy);
        await HomeWidget.saveWidgetData('dolar_sell', dolarSell);
        await HomeWidget.saveWidgetData('dolar_change', dolarChange);
      } else if (isAndroid) {
        await prefs?.setString('flutter.dolar_buy', dolarBuy);
        await prefs?.setString('flutter.dolar_sell', dolarSell);
        await prefs?.setString('flutter.dolar_change', dolarChange);
      }
    }

    CurrencyEntity euro = priceData.firstWhere(
        (element) => element.code == 'EURTRY',
        orElse: () => CurrencyEntity.empty());


    // EURO (EURTRY)
    if (euro.code != DefaultLocalStrings.emptyText) {
      final euroBuy = euro.alis.toString();
      final euroSell = euro.satis.toString();
      final euroChange = euro.fark.toString();

      if (isIOS) {
        await HomeWidget.saveWidgetData('euro_buy', euroBuy);
        await HomeWidget.saveWidgetData('euro_sell', euroSell);
        await HomeWidget.saveWidgetData('euro_change', euroChange);
      } else if (isAndroid) {
        await prefs?.setString('flutter.euro_buy', euroBuy);
        await prefs?.setString('flutter.euro_sell', euroSell);
        await prefs?.setString('flutter.euro_change', euroChange);
      }
    }

    CurrencyEntity gramSilver = priceData.firstWhere(
        (element) => element.code == 'GUMUSTRY',
        orElse: () => CurrencyEntity.empty());

    // GÜMÜŞ (GUMUSTRY)
    if (gramSilver.code != DefaultLocalStrings.emptyText) {
      final gumusBuy = gramSilver.alis.toString();
      final gumusSell = gramSilver.satis.toString();
      final gumusChange = gramSilver.fark.toString();

      if (isIOS) {
        await HomeWidget.saveWidgetData('gumus_buy', gumusBuy);
        await HomeWidget.saveWidgetData('gumus_sell', gumusSell);
        await HomeWidget.saveWidgetData('gumus_change', gumusChange);
      } else if (isAndroid) {
        await prefs?.setString('flutter.gumus_buy', gumusBuy);
        await prefs?.setString('flutter.gumus_sell', gumusSell);
        await prefs?.setString('flutter.gumus_change', gumusChange);
      }
    }

    // Son güncelleme saati
    String tarih = gramGold.tarih ?? "";
    String formattedTime = _extractTimeFromDate(tarih);

    if (isIOS) {
      await HomeWidget.saveWidgetData('lastUpdate', formattedTime);
      await HomeWidget.updateWidget(
          name: GeneralConstants.iosWidgetId,
          iOSName: GeneralConstants.iosWidgetId);
    } else if (isAndroid) {
      await prefs!.setString('flutter.lastUpdate', formattedTime);
      await HomeWidget.updateWidget(
          name: GeneralConstants.iosWidgetId,
          androidName: GeneralConstants.androidWidgetId, // Sadece sınıf adı
          qualifiedAndroidName: GeneralConstants.androidWidgetPath // Tam yol
          );
    }

    debugPrint(
        "[HeadlessTask] Widget başarıyla güncellendi (${isIOS ? 'iOS' : 'Android'})");
  } catch (e) {
    debugPrint("[HeadlessTask] Widget güncelleme hatası: $e");
  }
}

// Tarihten sadece saati çıkar: "04-10-2025 22:15:02" -> "22:15"
String _extractTimeFromDate(String tarih) {
  if (tarih.contains(' ')) {
    final parts = tarih.split(' ');
    if (parts.length >= 2) {
      final timePart = parts[1]; // "22:15:02"
      final timeComponents = timePart.split(':');
      if (timeComponents.length >= 2) {
        return '${timeComponents[0]}:${timeComponents[1]}'; // "22:15"
      }
    }
  }
  return '--:--';
}

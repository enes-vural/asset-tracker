import 'package:asset_tracker/data/service/cache/hive_cache_service.dart';
import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:asset_tracker/firebase_options.dart';
import 'package:asset_tracker/injection.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:home_widget/home_widget.dart';

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
        delay: 0, //1200000,
        periodic: false, //true, //false for testing
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

    // Mevcut sync işlemi
    final syncManager = backgroundContainer.read(syncManagerProvider);
    await syncManager.syncOfflineActionHeadless();

    final GetIt getIt = GetIt.instance;
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
Future<void> _updateHomeWidgetFromBackground(dynamic socketData) async {
  try {
    // Socket verisini parse et (senin data model'ine göre ayarla)
    // Örnek: Map<String, dynamic> priceData = socketData['data'];

    Map<String, dynamic> priceData =
        socketData; // Bunu kendi parse mantığınla değiştir

    // GRAM ALTIN (KULCEALTIN)
    if (priceData.containsKey('KULCEALTIN')) {
      await HomeWidget.saveWidgetData(
          'gramAltin_buy', priceData['KULCEALTIN']['alis'].toString());
      await HomeWidget.saveWidgetData(
          'gramAltin_sell', priceData['KULCEALTIN']['satis'].toString());

      // Change hesaplama (eğer fark field'ı varsa direkt kullan, yoksa hesapla)
      String change = _calculateChange(
        priceData['KULCEALTIN']['alis'],
        priceData['KULCEALTIN']['kapanis'],
      );
      await HomeWidget.saveWidgetData('gramAltin_change', change);
    }

    // DOLAR (USDTRY)
    if (priceData.containsKey('USDTRY')) {
      await HomeWidget.saveWidgetData(
          'dolar_buy', priceData['USDTRY']['alis'].toString());
      await HomeWidget.saveWidgetData(
          'dolar_sell', priceData['USDTRY']['satis'].toString());

      String change = _calculateChange(
        priceData['USDTRY']['alis'],
        priceData['USDTRY']['kapanis'],
      );
      await HomeWidget.saveWidgetData('dolar_change', change);
    }

    // EURO (EURTRY)
    if (priceData.containsKey('EURTRY')) {
      await HomeWidget.saveWidgetData(
          'euro_buy', priceData['EURTRY']['alis'].toString());
      await HomeWidget.saveWidgetData(
          'euro_sell', priceData['EURTRY']['satis'].toString());

      String change = _calculateChange(
        priceData['EURTRY']['alis'],
        priceData['EURTRY']['kapanis'],
      );
      await HomeWidget.saveWidgetData('euro_change', change);
    }

    // GÜMÜŞ (GUMUSTRY)
    if (priceData.containsKey('GUMUSTRY')) {
      await HomeWidget.saveWidgetData(
          'gumus_buy', priceData['GUMUSTRY']['alis'].toString());
      await HomeWidget.saveWidgetData(
          'gumus_sell', priceData['GUMUSTRY']['satis'].toString());

      String change = _calculateChange(
        priceData['GUMUSTRY']['alis'],
        priceData['GUMUSTRY']['kapanis'],
      );
      await HomeWidget.saveWidgetData('gumus_change', change);
    }

    // Son güncelleme saati - Tarihten sadece saat al
    String tarih = priceData['KULCEALTIN']?['tarih'] ??
        priceData['USDTRY']?['tarih'] ??
        '';
    String formattedTime = _extractTimeFromDate(tarih);
    await HomeWidget.saveWidgetData('lastUpdate', formattedTime);

    // Widget'ı güncelle
    await HomeWidget.updateWidget(
        name: 'parotawidget', iOSName: 'parotawidget');

    debugPrint("[HeadlessTask] Widget başarıyla güncellendi");
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

// Değişim yüzdesini hesapla
String _calculateChange(dynamic alis, dynamic kapanis) {
  try {
    double alisValue = double.parse(alis.toString().replaceAll(',', '.'));
    double kapanisValue = double.parse(kapanis.toString().replaceAll(',', '.'));

    if (kapanisValue == 0) return "0.00";

    double change = ((alisValue - kapanisValue) / kapanisValue) * 100;
    String formatted = change.toStringAsFixed(2);

    return change >= 0 ? "+$formatted" : formatted;
  } catch (e) {
    debugPrint("Change hesaplama hatası: $e");
    return "0.00";
  }
}

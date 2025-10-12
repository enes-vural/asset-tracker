import 'dart:convert';
import 'dart:io';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/constants/asset_constant.dart';
import 'package:asset_tracker/core/config/init/init.dart';
import 'package:asset_tracker/core/config/localization/localization_manager.dart';
import 'package:asset_tracker/core/constants/global/general_constants.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/routers/app_router.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/data/model/web/price_changed_model.dart';
import 'package:asset_tracker/data/service/background/background_service.dart';
import 'package:asset_tracker/data/service/cache/hive_cache_service.dart';
import 'package:asset_tracker/data/service/cache/icache_service.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/usecase/cache/cache_use_case.dart';
import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:asset_tracker/firebase_options.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/provider/theme_provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter/material.dart' hide Key;
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'
    show FlutterNativeSplash;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  print("Native called background task");
  Workmanager().executeTask((task, inputData) async {
    // HomeWidget.setAppGroupId(GeneralConstants.appGroupId);
    print("Native called background task: $task");
    print("TASK ID: $task");

    print("WORK MANAGER TASK GELDI OLEY");
    print("PERIODIC TASK GELDI OLEY");

    await updateUserWidget();

    if (!getIt.isRegistered<CacheUseCase>()) {
      setupDependencies(); // Dependency'leri tekrar register et
    }

    HiveCacheService hiveCacheService = HiveCacheService();
    await hiveCacheService.init();

    final backgroundContainer = ProviderContainer();

    // Mevcut sync işlemi
    final syncManager = backgroundContainer.read(syncManagerProvider);
    await syncManager.syncOfflineActionHeadless();

    backgroundContainer.dispose();

    return Future.value(true);
  });
}

Future<void> updateUserWidget() async {
  print("WORK MANAGER TASK GELDI SILENT NOTIF OLEY");
  print("PERIODIC TASK GELDI SILENT NOTIF OLEY");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // WebSocket bağlantısı kur ve widget'ı güncelle
  try {
    final FirebaseFunctions _functions = FirebaseFunctions.instance;

    final HttpsCallable request = _functions.httpsCallable('get_price_data');
    final rawData = await request.call();

    if (rawData.data['data'] == null || rawData.data['error'] != null) {
      print("Https call back get_price_data has error");
      return;
    }

    // print("RAW DATA" + rawData.data['data'].toString());

    final PriceChangedDataModel priceChangedModel =
        PriceChangedDataModel.fromJson(
            jsonDecode(rawData.data['data'].toString()));

    if (priceChangedModel.data.isEmpty) {
      print("Price change model data is null");
      return;
    }

    List<CurrencyEntity> currencyList = [];
    priceChangedModel.data.forEach(
      (element) {
        currencyList.add(CurrencyEntity.fromModel(element));
      },
    );

    await _updateHomeWidgetFromBackground(currencyList);
  } catch (e) {
    print("Error has been occurred " + e.toString());
  }
}

Future<void> _updateHomeWidgetFromBackground(
    List<CurrencyEntity> socketData) async {
  try {
    HomeWidget.setAppGroupId(GeneralConstants.appGroupId);
    List<CurrencyEntity> priceData = socketData;

    print("[HeadlessTask] Updating widget with data:");
    //debugPrint(socketData.toString());

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
        await prefs?.setString('gramAltin_buy', gramAltinBuy);
        await prefs?.setString('gramAltin_sell', gramAltinSell);
        await prefs?.setString('gramAltin_change', gramAltinChange);
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
        await prefs?.setString('dolar_buy', dolarBuy);
        await prefs?.setString('dolar_sell', dolarSell);
        await prefs?.setString('dolar_change', dolarChange);
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
        await prefs?.setString('euro_buy', euroBuy);
        await prefs?.setString('euro_sell', euroSell);
        await prefs?.setString('euro_change', euroChange);
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
        await prefs?.setString('gumus_buy', gumusBuy);
        await prefs?.setString('gumus_sell', gumusSell);
        await prefs?.setString('gumus_change', gumusChange);
      }
    }

    // Son güncelleme saati
    String tarih = gramGold.tarih ?? "";
    String formattedTime = false
        ? DateTime.now().hour.toString() +
            ":" +
            DateTime.now().minute.toString()
        : _extractTimeFromDate(tarih);

    if (isIOS) {
      await HomeWidget.saveWidgetData('lastUpdate', formattedTime);
      await HomeWidget.updateWidget(
        name: GeneralConstants.iosWidgetId,
        iOSName: GeneralConstants.iosWidgetId,
      );
    } else if (isAndroid) {
      await prefs!.setString('lastUpdate', formattedTime);
      await HomeWidget.updateWidget(
        name: GeneralConstants.iosWidgetId,
        androidName: GeneralConstants.androidWidgetId, // Sadece sınıf adı
      );
    }

    print(
        "[HeadlessTask] Widget başarıyla güncellendi (${isIOS ? 'iOS' : 'Android'})");
  } catch (e) {
    print("[HeadlessTask] Widget güncelleme hatası: $e");
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background silent message received: ${message.data}");
  await updateUserWidget();
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Application Init here !
  // Background fetch setup
  // if (!(Platform.isIOS && kDebugMode)) {
  // Workmanager().cancelAll();
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
  await AppInit.initialize();
  // await BackgroundService.instance.init();

  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  // BackgroundService.instance
  //     .addNewHeadlessTask('com.transistorsoft.customtask');
  // }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print("Silent notification geldi: ${message.data}");
  //   updateUserWidget();
  // });
  runApp(EasyLocalization(
    // Localization setup in runApp
    supportedLocales: LocalizationManager.supportedTranslations,
    fallbackLocale: LocalizationManager.fallBackLocale,
    path: AssetConstant.translationPath,
    child: const ProviderScope(
      child: MyApp(),
    ),
  ));

  FlutterNativeSplash.remove();
}

final appRouter = AppRouter();
String versionUrl =
    "https://raw.githubusercontent.com/enes-vural/asset-tracker/main/updates/appcast.xml";

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Init current user before app starts
    ref.read(authGlobalProvider.notifier).initCurrentUser(ref);
    // AsyncNotifier ile tema state'ini izle
    final appThemeAsync = ref.watch(appThemeProvider);

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: DefaultColorPalette.vanillaTranparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          child: appThemeAsync.when(
            // Loading durumu - tema yüklenirken
            loading: () => _loadingMaterialApp(),

            // Error durumu - tema yüklenemediğinde
            error: (error, stackTrace) {
              debugPrint('Theme loading error: $error');
              return _fallbackMaterialApp(context);
            },

            // Data durumu - tema başarıyla yüklendiğinde
            data: (appThemeState) => _buildMaterialApp(context, appThemeState),
          )),
    );
  }

  MediaQuery _buildMaterialApp(
      BuildContext context, AppThemeState appThemeState) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: MaterialApp.router(
        localizationsDelegates: LocalizationManager().delegates(context),
        supportedLocales: LocalizationManager().supportedLocales(context),
        locale: LocalizationManager().locale(context),
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(),
        title: LocaleKeys.app_title.tr(),
        theme: defaultTheme,
        darkTheme: darkTheme,
        themeMode: appThemeState.currentTheme, // Yüklenen tema
      ),
    );
  }

  MaterialApp _fallbackMaterialApp(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: LocalizationManager().delegates(context),
      supportedLocales: LocalizationManager().supportedLocales(context),
      locale: LocalizationManager().locale(context),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(),
      title: LocaleKeys.app_title.tr(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
    );
  }

  MaterialApp _loadingMaterialApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: LocaleKeys.app_title.tr(),
      theme: ThemeData.light(), // Default tema
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

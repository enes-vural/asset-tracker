import 'dart:io';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/constants/asset_constant.dart';
import 'package:asset_tracker/core/config/init/init.dart';
import 'package:asset_tracker/core/config/localization/localization_manager.dart';
import 'package:asset_tracker/core/routers/app_router.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/data/service/background/background_service.dart';
import 'package:asset_tracker/injection.dart';
import 'package:asset_tracker/provider/theme_provider.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'
    show FlutterNativeSplash;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  // Application Init here !
  await AppInit.initialize();

  runApp(EasyLocalization(
    // Localization setup in runApp
    supportedLocales: LocalizationManager.supportedTranslations,
    fallbackLocale: LocalizationManager.fallBackLocale,
    path: AssetConstant.translationPath,
    child: const ProviderScope(
      child: MyApp(),
    ),
  ));

  // Background fetch setup
  if (!(Platform.isIOS && kDebugMode)) {
    await BackgroundService.instance.init();
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    BackgroundService.instance
        .addNewHeadlessTask('com.transistorsoft.customtask');
  }

  FlutterNativeSplash.remove();
}

final appRouter = AppRouter();

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

  MaterialApp _buildMaterialApp(
      BuildContext context, AppThemeState appThemeState) {
    return MaterialApp.router(
      localizationsDelegates: LocalizationManager().delegates(context),
      supportedLocales: LocalizationManager().supportedLocales(context),
      locale: LocalizationManager().locale(context),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(),
      title: LocaleKeys.app_title.tr(),
      theme: defaultTheme,
      darkTheme: darkTheme,
      themeMode: appThemeState.currentTheme, // Yüklenen tema
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

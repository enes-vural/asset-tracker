import 'package:asset_tracker/core/config/constants/asset_constant.dart';
import 'package:asset_tracker/core/config/init/init.dart';
import 'package:asset_tracker/core/config/localization/localization_manager.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/routers/app_router.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/data/service/background/background_service.dart';
import 'package:asset_tracker/injection.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  //Application Init here !
  //--------------------
  await AppInit.initialize();
  //--------------------

  runApp(EasyLocalization(
    //----------------------------------
    //Localization setup in runApp
    supportedLocales: LocalizationManager.supportedTranslations,
    //if there is no keywork in json automatically returns fallback's keyword
    //so in this point, if our turkish.json had a error automatically english
    //keyword returns !
    fallbackLocale: LocalizationManager.fallBackLocale,
    path: AssetConstant.translationPath,
    //----------------------------------
    child: const ProviderScope(child: MyApp()),
  ));
  await BackgroundService.instance.init();
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  BackgroundService.instance
      .addNewHeadlessTask('com.transistorsoft.customtask');
}

final appRouter = AppRouter();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //init current user before app starts
    //because firebase auth state changes are delayed.
    ref.read(authGlobalProvider.notifier).initCurrentUser(ref);
    return MaterialApp.router(
      //---------------------------------- b
      //Localization setup in Material App
      localizationsDelegates: LocalizationManager().delegates(context),
      supportedLocales: LocalizationManager().supportedLocales(context),
      locale: LocalizationManager().locale(context),
      //----------------------------------
      //remove debug banner on top left
      debugShowCheckedModeBanner: false,
      // Router configrated to app
      routerConfig: appRouter.config(),
      //title of app
      title: LocaleKeys.app_title.tr(),
      theme: defaultTheme,
    );
  }
}

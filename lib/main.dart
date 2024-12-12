import 'package:asset_tracker/core/config/constants/asset_constant.dart';
import 'package:asset_tracker/core/config/init/init.dart';
import 'package:asset_tracker/core/config/localization/localization_manager.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/routers/app_router.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main() async {
  //TODO: System navigation bar color will change in initial
  //TODO: Theme data and color palette confused
  //TODO: Create Json File or String class for texts.

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
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MaterialApp.router(
      //----------------------------------
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

import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/default_theme.dart';
import 'package:asset_tracker/core/routers/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  //TODO: System navigation bar color will change in initial
  //TODO: Theme data and color palette confused
  //TODO: Create Json File or String class for texts.
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MaterialApp.router(
      
      //remove debug banner on top left
      debugShowCheckedModeBanner: false,
      // Router configrated to app
      routerConfig: appRouter.config(),
      //title of app
      title: DefaultLocalStrings.appTitle,
      theme: defaultTheme,
    );
  }
}

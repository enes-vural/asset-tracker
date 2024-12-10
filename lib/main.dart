import 'package:asset_tracker/core/routers/app_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  //TODO: System navigation bar color will change in initial
  //TODO: Create ThemeData class for define colors and fonts.
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
      title: 'Gold Exchance |',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color.fromARGB(161, 5, 34, 48),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color.fromARGB(177, 5, 34, 48),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

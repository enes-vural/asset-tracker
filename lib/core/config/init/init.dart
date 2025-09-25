import 'package:asset_tracker/data/service/cache/hive_cache_service.dart';
import 'package:asset_tracker/injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../env/envied.dart';
import '../../../firebase_options.dart';

final class AppInit {
  static Future<void> initialize() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    Env(); //Envied Initialize
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    HiveCacheService.instance.init();
    await setupDependencies();
    await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );

    // if (kDebugMode) {
    //   await FirebaseAppCheck.instance.activate(
    //     androidProvider: AndroidProvider.debug,
    //     appleProvider: AppleProvider.debug,
    //   );
    // } else {
    //   await FirebaseAppCheck.instance.activate(
    //     androidProvider: AndroidProvider.playIntegrity,
    //     appleProvider: AppleProvider.deviceCheck,
    //     //for debug
    //     // androidProvider: AndroidProvider.debug,
    //     // appleProvider: AppleProvider.debug,
    //   );
    // }
    debugPrint("All services initialized");
  }
}

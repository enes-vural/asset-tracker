import 'package:asset_tracker/data/service/cache/hive_cache_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../../env/envied.dart';
import '../../../firebase_options.dart';

final class AppInit {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    HiveCacheService.instance.init();
    Env.setup(); //Envied Initialize
  }
}

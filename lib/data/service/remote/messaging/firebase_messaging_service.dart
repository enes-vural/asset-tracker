import 'dart:io';

import 'package:asset_tracker/data/service/remote/messaging/imessaging_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';

final class FirebaseMessagingService implements IMessagingService {
  final FirebaseMessaging instance;

  FirebaseMessagingService({required this.instance});

  @override
  Future<void> initialize() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isAuthorized() async {
    NotificationSettings settings = await instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    try {
      if (Platform.isAndroid) {
        PermissionStatus isAndroidVerify =
            await Permission.notification.request();
        return (settings.authorizationStatus ==
                AuthorizationStatus.authorized &&
            isAndroidVerify == PermissionStatus.denied);
      }
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final fcmToken = await instance.getToken();
      debugPrint("FCM TOKEN : $fcmToken");
      return fcmToken;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}

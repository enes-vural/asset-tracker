import 'dart:async';
import 'package:asset_tracker/data/model/web/error/socket_error_model.dart';

abstract interface class IWebSocketService {
  StreamController<Map<String, dynamic>> get controller;
  StreamController<dynamic> get errorController;

  Stream<Map<String, dynamic>> get stream;

  Stream<SocketErrorModel> get errorStream;

  StreamController get getController;

  StreamController get getErrorController;
  //şimdilik dnyamic olarak kalabilir sonrasında değişecek

  Future<void> connectSocket();

  Future<void> closeSocket();
}

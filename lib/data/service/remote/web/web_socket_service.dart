import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:asset_tracker/data/model/web/response/socket_state_response_model.dart';
import 'package:asset_tracker/data/service/remote/web/iweb_socket_service.dart';
import 'package:flutter/material.dart';
import '../../../../env/envied.dart';
import '../../../model/web/error/socket_error_model.dart';

class WebSocketService implements IWebSocketService {
  @override
  final StreamController<Map<String, dynamic>> controller =
      StreamController.broadcast();
  @override
  final StreamController<SocketErrorModel> errorController =
      StreamController.broadcast();

  WebSocket? socket;

  @override
  Future<void> connectSocket() async {
    try {
      errorController.add(const SocketErrorModel(
          message: "Connection to socket", state: SocketStateEnum.INIT));
      socket ??= await WebSocket.connect(Env.setup().socketApi);
      await _listenSocket();
    } catch (error) {
      //şimdilik direkt olarka error str yi veriyoruz ama api a bağlı olarak
      //enum oluşturulup gelen stringin enum a çevrilmesi sağlanabilir
      _handleSocketError(error.toString());
    }
  }

  Future<void> clearSockets() async {
    if (socket != null) {
      await socket!.close();
      socket = null;
    }
  }

  void _handleSocketError(String error) {
    debugPrint("Error occurred: $error");
    errorController
        .add(SocketErrorModel(message: error, state: SocketStateEnum.ERROR));
  }

  Future<void> _listenSocket() async {
    if (socket != null) {
      socket!.listen(
        (event) {
          final data = event.toString();

          //--------------------------------------
          if (data.startsWith('0')) {
            debugPrint("Inital Call");
            socket!.add('40');
            debugPrint(data);
          } else if (data == '2') {
            debugPrint("Refresh...");
            socket!.add('40');
          } else if (data.substring(0, 2) == '42') {
            debugPrint(data.substring(19, event.toString().length - 1));
            final jsonData =
                jsonDecode(data.substring(19, event.toString().length - 1))
                    as Map<String, dynamic>;
            controller.add(jsonData);
          }
        },
        onError: (err) async {
          _handleSocketError(err);

          debugPrint("ERROR OCCURRED : $err");
          await reconnect();
        },
        onDone: () async {
          debugPrint("DONE DONE DONE");
          await reconnect();
        },
        cancelOnError: true,
      );
    }
  }

  @override
  Stream<Map<String, dynamic>> get stream => controller.stream;

  @override
  Stream<SocketErrorModel> get errorStream => errorController.stream;

  Future<void> reconnect() async {
    debugPrint("Reconnecting...");
    await socket?.close();
    socket = null;
    await Future.delayed(
        const Duration(seconds: 3)); // Bir süre bekleyip yeniden bağlan
    await connectSocket();
  }

  @override
  Future<void> closeSocket() async {
    await socket?.close();
    socket = null;
    controller.close();
  }
}
//test@gmail.com

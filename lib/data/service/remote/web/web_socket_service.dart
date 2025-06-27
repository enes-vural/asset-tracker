import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:asset_tracker/core/constants/enums/socket/socket_state_enums.dart';
import 'package:asset_tracker/core/constants/global/general_constants.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/data/service/remote/web/iweb_socket_service.dart';
import 'package:easy_localization/easy_localization.dart';
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

      errorController.add(SocketErrorModel(
          message: LocaleKeys.home_socketConnectionInit.tr(),
          state: SocketStateEnum.INIT));
      //error state yenileniyor init durumuna geçiyor
      //ek olarak connection done olunca errorState yenilenebilir ama basit düzeyde
      //sadece error dinlediğimiz için şu an gerek yok.
      socket ??= await WebSocket.connect(Env().socketApi);
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
          final String data = event.toString();
          //--------------------------------------
          //ilk data geldiği zaman
          if (data.startsWith(SocketActionEnum.INIT_DATA.value)) {
            debugPrint("Inital Call");
            socket!.add(SocketActionEnum.REQUEST.value);
            debugPrint(data);
          }
          //refresh durumu gerektiği zaman
          else if (data == SocketActionEnum.REFRESH.value) {
            debugPrint("Refresh...");
            socket?.add(SocketActionEnum.REQUEST.value);
          }
          //resend durumu gerektiği zaman
          else if (_checkJsonFirstIndex(event) ==
              SocketActionEnum.RESEND.value) {
            // debugPrint(_jsonDecodeSocketData(event).toString());
            final jsonData = _jsonDecodeSocketData(event);
            controller.add(jsonData);
          }
        },
        onError: (err) async {
          //cancelOnError true olduğu için buraya düşmeyecek ama yine de yazıldı
          _handleSocketError(err);
          debugPrint("ERROR OCCURRED : $err");
          await reconnect();
        },
        onDone: () async {
          debugPrint("\nDONE");
          await reconnect();
        },
        cancelOnError: true,
      );
    }
  }

  @override
  Stream<Map<String, dynamic>> get stream =>
      controller.stream.asBroadcastStream();

  @override
  StreamController get getController => controller;

  @override
  StreamController get getErrorController => errorController;

  @override
  Stream<SocketErrorModel> get errorStream =>
      errorController.stream.asBroadcastStream();

  Future<void> reconnect() async {
    debugPrint("Reconnecting...");
    await socket?.close();
    socket = null;
    await Future.delayed(
        const Duration(seconds: GeneralConstants.delayBetweenReconnect));
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

//şimdilik dynamic kalabilir
int _socketParsedLength(dynamic event) => event.toString().length - 1;

dynamic _jsonDecodeSocketData(dynamic event) => jsonDecode(event.substring(
    GeneralConstants.socketJsonInitialIndex, _socketParsedLength(event)));

String _checkJsonFirstIndex(dynamic event) =>
    event.toString().substring(0, GeneralConstants.socketFirstDoubleIndexJson);

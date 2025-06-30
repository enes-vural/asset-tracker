import 'dart:async';

import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class WebSocketState {
  final Stream? socketDataStream;
  final bool isConnected;
  final String? error;

  WebSocketState({
    this.socketDataStream,
    this.isConnected = false,
    this.error,
  });

  WebSocketState copyWith({
    Stream? socketDataStream,
    bool? isConnected,
    String? error,
  }) {
    return WebSocketState(
      socketDataStream: socketDataStream ?? this.socketDataStream,
      isConnected: isConnected ?? this.isConnected,
      error: error ?? this.error,
    );
  }
}

class WebSocketNotifier extends StateNotifier<WebSocketState> {
  WebSocketNotifier() : super(WebSocketState());

  StreamController? dataStreamController;
  final GetSocketStreamUseCase getSocketStreamUseCase =
      GetIt.instance<GetSocketStreamUseCase>();

  Future<void> initializeSocket() async {
    if (dataStreamController?.stream != null) {
      return;
    }

    final data = await getSocketStreamUseCase.call(null);
    data.fold((failure) {
      debugPrint(failure.message);
      state = state.copyWith(error: failure.message, isConnected: false);
    }, (success) {
      debugPrint("Connection STATE : ${success.state}");
      dataStreamController = getSocketStreamUseCase.controller;
      final socketStream = dataStreamController?.stream.asBroadcastStream();

      state = state.copyWith(
        socketDataStream: socketStream,
        isConnected: true,
        error: null,
      );
    });
  }

  @override
  void dispose() {
    dataStreamController?.close();
    super.dispose();
  }
}

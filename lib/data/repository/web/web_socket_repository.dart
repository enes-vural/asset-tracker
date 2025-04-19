// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:asset_tracker/core/constants/enums/socket/socket_state_enums.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/data/model/web/error/socket_error_model.dart';
import 'package:asset_tracker/data/model/web/price_changed_model.dart';
import 'package:asset_tracker/data/model/web/response/socket_state_response_model.dart';
import 'package:asset_tracker/data/service/remote/web/iweb_socket_service.dart';
import 'package:asset_tracker/domain/entities/web/error/socket_error_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../domain/repository/web/iweb_socket_repository.dart';

class WebSocketRepository implements IWebSocketRepository {
  final IWebSocketService socketService;

  final List<CurrencyEntity> _currencyEntities = []; // CurrencyEntity listesi

  StreamController<List<CurrencyEntity>>? _controller;
  StreamController<Either<SocketErrorEntity, SocketStateResponseModel>>?
      _errorController;

  WebSocketRepository({required this.socketService});

  @override
  Future<Either<SocketErrorEntity, SocketStateResponseModel>>
      startConnection() async {
    try {
      _controller = StreamController.broadcast();
      _errorController = StreamController.broadcast();

      socketService.errorStream.listen(
        (SocketErrorModel model) {
          model.state == SocketStateEnum.ERROR
              ? _errorController?.add(Left(SocketErrorEntity.fromModel(model)))
              : _errorController?.add(Right(
                  SocketStateResponseModel(
                      model.message ?? DefaultLocalStrings.emptyText,
                      model.state),
                ));
        },
      );
      await socketService.connectSocket();
      socketService.stream.listen((jsonData) {
        debugPrint("DATA CAME !!!");

        final priceChangedModel = PriceChangedDataModel.fromJson(jsonData);

        priceChangedModel.data.forEach((element) {
          final CurrencyEntity currencyEntity =
              CurrencyEntity.fromModel(element);

          final index = _currencyEntities
              .indexWhere((entity) => entity.code == currencyEntity.code);

          if (index == int.parse(SocketActionEnum.NOT_IN_LIST.value)) {
            // Entity listede yoksa, yeni öğeyi ekle
            _currencyEntities.add(currencyEntity);
            debugPrint("New currency added: ${currencyEntity.code}");
          } else {
            // Entity listede varsa, hash'lerini karşılaştır
            final existingEntity = _currencyEntities[index];
            if (existingEntity.hash != currencyEntity.hash) {
              // Eğer hash farklıysa, öğeyi güncelle
              _currencyEntities[index] = currencyEntity;
              debugPrint("Currency updated: ${currencyEntity.code}");
            }
          }
        });

        //değişmez liste olarak veriyi stream e ekle
        _controller!.add(List.unmodifiable(_currencyEntities));
        debugPrint(
            "Currency list updated, total items: ${_currencyEntities.length}");
      });
      return const Right(
          SocketStateResponseModel("Connected...", SocketStateEnum.CONNECTED));
    } catch (error) {
      return Left(SocketErrorEntity.fromModel(SocketErrorModel(
          message: error.toString(), state: SocketStateEnum.ERROR)));
    }
  }

  /*
  void handleSocketData(Map<String, dynamic> json) {
    _controller.add(json);
  }
  */
  @override
  Future<void> closeStream() async {
    await socketService.closeSocket();
    //_controller?.close();
  }

  //repoların streamleri
  @override
  Stream? get stream => _controller?.stream.asBroadcastStream();

  @override
  StreamController? get errorController => _errorController;

  @override
  StreamController? get controller => _controller;

  @override
  Stream<Either<SocketErrorEntity, SocketStateResponseModel>>?
      get errorStream => _errorController?.stream.asBroadcastStream();
}

//test@gmail.com

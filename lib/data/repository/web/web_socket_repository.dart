// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:asset_tracker/core/constants/enums/socket/socket_state_enums.dart';
import 'package:asset_tracker/core/constants/filtered_codes_constants.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/data/model/web/currency_model.dart';
import 'package:asset_tracker/data/model/web/error/socket_error_model.dart';
import 'package:asset_tracker/data/model/web/price_changed_model.dart';
import 'package:asset_tracker/data/model/web/response/socket_state_response_model.dart';
import 'package:asset_tracker/data/service/cache/icache_service.dart';
import 'package:asset_tracker/data/service/remote/web/iweb_socket_service.dart';
import 'package:asset_tracker/domain/entities/web/error/socket_error_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../domain/repository/web/iweb_socket_repository.dart';

class WebSocketRepository implements IWebSocketRepository {
  final IWebSocketService socketService;
  final ICacheService _cacheService;

  final List<CurrencyEntity> _currencyEntities = []; // CurrencyEntity listesi
  final List<CurrencyModel> rawCurrencyList = []; // CurrencyModel listesi

  StreamController<List<CurrencyEntity>>? _controller;
  StreamController<Either<SocketErrorEntity, SocketStateResponseModel>>?
      _errorController;

  WebSocketRepository(
      {required this.socketService, required ICacheService cacheService})
      : _cacheService = cacheService;

  @override
  startConnection() async {
    bool isFirstConnection = true;
    final Set<String> filter = FilteredCodesConstants.filteredCodes;

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
        // debugPrint("DATA CAME !!!");
        final priceChangedModel = PriceChangedDataModel.fromJson(jsonData);

        // İlk bağlantıda: rawCurrencyList'i doldur ve cache'e kaydet
        if (isFirstConnection) {
          priceChangedModel.data.forEach((element) {
            if (!filter.contains(element.code.toUpperCase())) {
              rawCurrencyList.add(element);
            }
          });
          //eğer data yanlış geldiyse 29 dan azsa cache e atma ve tekrar bekle
          if (rawCurrencyList.length < 29) {
            isFirstConnection = true;
            return;
          }

          // Bir kerelik cache işlemi
          _cacheService.saveCurrencyList(rawCurrencyList);

          isFirstConnection = false;
          debugPrint(
              "✅ FIRST CONNECTION: ${rawCurrencyList.length} items cached to HIVE");
        }

        priceChangedModel.data.forEach((element) {
          if (filter.contains(element.code.toUpperCase())) {
            return;
          }

          final CurrencyEntity currencyEntity =
              CurrencyEntity.fromModel(element);

          final index = _currencyEntities
              .indexWhere((entity) => entity.code == currencyEntity.code);

          if (index == int.parse(SocketActionEnum.NOT_IN_LIST.value)) {
            _currencyEntities.add(currencyEntity);
          } else {
            final existingEntity = _currencyEntities[index];
            if (existingEntity.hash != currencyEntity.hash) {
              _currencyEntities[index] = currencyEntity;
            }
          }
        });

//değişmez liste olarak veriyi stream e ekle
        _controller?.add(List.unmodifiable(_currencyEntities));
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

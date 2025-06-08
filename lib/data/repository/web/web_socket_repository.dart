// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:asset_tracker/core/constants/enums/socket/socket_state_enums.dart';
import 'package:asset_tracker/core/constants/filtered_codes_constants.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/data/model/web/direction_model.dart';
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
  startConnection() async {
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
        debugPrint("DATA CAME !!!");
final priceChangedModel = PriceChangedDataModel.fromJson(jsonData);

// ONS ve USD/TRY değerlerini tutacak değişkenler
        CurrencyEntity? onsAltinEntity;
        CurrencyEntity? usdTryEntity;

        priceChangedModel.data.forEach((element) {
          final CurrencyEntity currencyEntity =
              CurrencyEntity.fromModel(element);

// ONS ve USD/TRY değerlerini sakla
          if (currencyEntity.code.toUpperCase() == 'ONS') {
            onsAltinEntity = currencyEntity;
          }
          if (currencyEntity.code.toUpperCase() == 'USDTRY') {
            usdTryEntity = currencyEntity;
          }

// **FİLTRE KONTROLÜ - Bu kod filtrelenmişse işleme alma**
          if (filter.contains(currencyEntity.code.toUpperCase())) {
            debugPrint("Currency filtered out: ${currencyEntity.code}");
            return; // Bu currency'i işleme alma
          }
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

// GRAM ALTIN HESAPLAMASI
        if (onsAltinEntity != null && usdTryEntity != null) {
          _calculateAndAddGramGold(onsAltinEntity!, usdTryEntity!);
        }

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

  void _calculateAndAddGramGold(
      CurrencyEntity onsEntity, CurrencyEntity usdTryEntity) {
    try {
      // ONS fiyatları
      final double onsAlis = double.tryParse(onsEntity.alis) ?? 0.0;
      final double onsSatis = double.tryParse(onsEntity.satis) ?? 0.0;

      // USD/TRY kurları
      final double usdTryAlis = double.tryParse(usdTryEntity.alis) ?? 0.0;
      final double usdTrySatis = double.tryParse(usdTryEntity.satis) ?? 0.0;

      // Gram altın hesaplaması
      // Gram Altın Alış = (ONS Alış × USD/TRY Alış) / 31.1035
      final double gramAltinAlis = (onsAlis * usdTryAlis) / 31.1035;

      // Gram Altın Satış = (ONS Satış × USD/TRY Satış) / 31.1035
      final double gramAltinSatis = (onsSatis * usdTrySatis) / 31.1035;

      // Gram altın entity'si oluştur
      final gramAltinEntity = CurrencyEntity(
        code: 'GRAMALTIN', // veya 'GRAM_ALTIN'
        dir: Direction(
            alisDir:
                _calculateDirection(gramAltinAlis, _getPreviousGramGoldAlis()),
            satisDir: _calculateDirection(
                gramAltinSatis, _getPreviousGramGoldSatis())),
        alis: gramAltinAlis.toString(),
        satis: gramAltinSatis.toString(),
        dusuk: "0",
        yuksek: "0",
        tarih: "",
        kapanis: "",
      );

      // Mevcut gram altın kaydını bul
      final gramAltinIndex =
          _currencyEntities.indexWhere((entity) => entity.code == 'GRAMALTIN');

      if (gramAltinIndex == int.parse(SocketActionEnum.NOT_IN_LIST.value)) {
        // Gram altın listede yoksa, yeni öğeyi ekle
        _currencyEntities.add(gramAltinEntity);
        debugPrint(
            "Gram altın added with Alış: $gramAltinAlis, Satış: $gramAltinSatis");
      } else {
        // Gram altın listede varsa, hash'lerini karşılaştır
        final existingGramAltin = _currencyEntities[gramAltinIndex];
        if (existingGramAltin.hash != gramAltinEntity.hash) {
          // Eğer hash farklıysa, öğeyi güncelle
          _currencyEntities[gramAltinIndex] = gramAltinEntity;
          debugPrint(
              "Gram altın updated with Alış: $gramAltinAlis, Satış: $gramAltinSatis");
        }
      }
    } catch (error) {
      debugPrint("Gram altın calculation error: $error");
    }
  }

  // Yön hesaplama fonksiyonu (artış/azalış)
  String _calculateDirection(double currentValue, double? previousValue) {
    if (previousValue == null) return ""; // İlk değer
    if (currentValue > previousValue) return "Up"; // Artış
    if (currentValue < previousValue) return "Down"; // Azalış
    return "";
  }

// Önceki gram altın alış değerini getir
  double? _getPreviousGramGoldAlis() {
    final gramAltinIndex =
        _currencyEntities.indexWhere((entity) => entity.code == 'GRAMALTIN');
    return gramAltinIndex != -1
        ? double.tryParse(_currencyEntities[gramAltinIndex].alis)
        : null;
  }

// Önceki gram altın satış değerini getir
  double? _getPreviousGramGoldSatis() {
    final gramAltinIndex =
        _currencyEntities.indexWhere((entity) => entity.code == 'GRAMALTIN');
    return gramAltinIndex != -1
        ? double.tryParse(_currencyEntities[gramAltinIndex].satis)
        : null;
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

import 'dart:async';

import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../data/model/web/response/socket_state_response_model.dart';
import '../../../domain/entities/web/error/socket_error_entity.dart';

class HomeViewModel extends ChangeNotifier {
  final GetSocketStreamUseCase getSocketStreamUseCase;

  HomeViewModel({required this.getSocketStreamUseCase});

  final TextEditingController searchBarController = TextEditingController();

  Stream? stream;

  StreamController? dataStreamController;

  Future<void> getData() async {
    //if stream is already open, we don't need to open it again
    if (dataStreamController?.stream != null) {
      return;
    }

    final data = await getSocketStreamUseCase.call(null);
    debugPrint(data.toString());
    data.fold((failure) => debugPrint(failure.message), (success) {
      debugPrint("Connection STATE : ${success.state}");
    });

    dataStreamController = getSocketStreamUseCase.controller;
    notifyListeners();
  }

  Future<void> getErrorStream({required BuildContext parentContext}) async {
    final Stream<Either<SocketErrorEntity, SocketStateResponseModel>>? data =
        getSocketStreamUseCase.getErrorStream();
    data?.listen((event) {
      event.fold((failure) {
        EasySnackBar.show(parentContext, failure.message);
      }, (success) {
        debugPrint("Connection STATE : ${success.state}");
        debugPrint("Connection STATE : ${success.message}");
      });
    });
  }

  List<CurrencyEntity> filterCurrencyData(List<CurrencyEntity> data) {
    String searchedCurrency = searchBarController.text;
    //filter the list via controller's value
    if (searchedCurrency.isNotEmpty) {
      final filteredData = data.where((CurrencyEntity element) {
        return element.code
                .toLowerCase()
                .contains(searchedCurrency.toLowerCase()) ||
            setCurrencyLabel(element.code)
                .toLowerCase()
                .contains(searchedCurrency.toLowerCase());
      }).toList();

      debugPrint("Filtered Data : ${filteredData.length}");
      return filteredData;
      //TODO: filtered data tarafında Unit test yazılabilir.
    }
    return data;
  }

  Stream? getStream() => dataStreamController?.stream.asBroadcastStream();

  // we will get stream after ensure connection is done !
}

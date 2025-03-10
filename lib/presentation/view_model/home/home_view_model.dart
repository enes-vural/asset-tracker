import 'dart:async';

import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/core/routers/app_router.gr.dart';
import 'package:asset_tracker/core/routers/router.dart' show Routers;
import 'package:asset_tracker/domain/entities/database/enttiy/usar_data_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_currency_entity_model.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/web/response/socket_state_response_model.dart';
import '../../../domain/entities/web/error/socket_error_entity.dart';

class HomeViewModel extends ChangeNotifier {
  final GetSocketStreamUseCase getSocketStreamUseCase;

  HomeViewModel({required this.getSocketStreamUseCase});

  final TextEditingController searchBarController = TextEditingController();

  StreamController? dataStreamController;
  Stream? socketDataStream;

  final StreamController<String> _searchBarStreamController =
      StreamController<String>();

  initHomeView() {
    searchBarController.addListener(() {
      _searchBarStreamController.add(searchBarController.text);
    });
  }

  Future<void> getData(WidgetRef ref) async {
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
    socketDataStream = dataStreamController?.stream.asBroadcastStream();

    ref.read(appGlobalProvider.notifier).updateSocketCurrency(socketDataStream);
    notifyListeners();
  }

  calculateProfitBalance(WidgetRef ref, List<CurrencyEntity>? globalAssets) {
    final UserDataEntity? userData =
        ref.read(appGlobalProvider.notifier).getUserData;
    List<UserCurrencyEntityModel> userCurrencyList =
        userData?.currencyList ?? [];

    double userBalance = userData?.balance ?? 0.00;
    double newBalance = 0;

    double totalProfit = 0.00;

    CurrencyEntity? currency;

    userCurrencyList.forEach((element) {
      try {
        currency = globalAssets?.firstWhere(
          (elementCurrency) => elementCurrency.code == element.currencyCode,
        );
      } catch (e) {
        currency = null;
      }

      if (currency != null) {
        newBalance += (double.parse(currency!.satis) * element.amount);
      }
    });

    totalProfit = newBalance * userBalance / 100;

    if (userData != null) {
      ref.read(appGlobalProvider.notifier).updateUserData(
          userData.copyWith(balance: newBalance, profit: totalProfit));
      notifyListeners();
    }
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

  filterCurrencyData(List<CurrencyEntity>? data, String searchedCurrency) {
    //filter the list via controller's value
    if (searchedCurrency.isNotEmpty && searchedCurrency != "") {
      final filteredData = data?.where((CurrencyEntity element) {
        return element.code
                .toLowerCase()
                .contains(searchedCurrency.toLowerCase()) ||
            setCurrencyLabel(element.code)
                .toLowerCase()
                .contains(searchedCurrency.toLowerCase());
      }).toList();

      return filteredData;
    }
    return data;
  }

  void routeTradePage(BuildContext context, CurrencyEntity currency) {
    Routers.instance
        .pushWithInfo(context, TradeRoute(currecyCode: currency.code));
  }

  Stream? get searchBarStreamController => _searchBarStreamController.stream;
  Stream get getEmptyStream => const Stream.empty(broadcast: true);
  // we will get stream after ensure connection is done !
}

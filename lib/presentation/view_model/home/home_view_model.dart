import 'dart:async';
import 'package:asset_tracker/core/routers/router.dart' show Routers;
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


  StreamController? dataStreamController;
  Stream? socketDataStream;

  double? newBalance;
  double? totalProfit;

  final StreamController<String> _searchBarStreamController =
      StreamController<String>.broadcast();


  Future<void> getData(WidgetRef ref) async {
    //if stream is already open, we don't need to open it again
    if (dataStreamController?.stream != null) {
      return;
    }

    final data = await getSocketStreamUseCase.call(null);
    // debugPrint(data.toString());
    data.fold((failure) => debugPrint(failure.message), (success) {
      debugPrint("Connection STATE : ${success.state}");
    });

    dataStreamController = getSocketStreamUseCase.controller;
    socketDataStream = dataStreamController?.stream.asBroadcastStream();

    ref.read(appGlobalProvider.notifier).updateSocketCurrency(socketDataStream);
    notifyListeners();
  }


  Future<void> getErrorStream({required BuildContext parentContext}) async {
    final Stream<Either<SocketErrorEntity, SocketStateResponseModel>>? data =
        getSocketStreamUseCase.getErrorStream();
    data?.listen((event) {
      event.fold((failure) {
        //commented for UX
        //EasySnackBar.show(parentContext, failure.message);
      }, (success) {
        debugPrint("Connection STATE : ${success.state}");
        debugPrint("Connection STATE : ${success.message}");
      });
    });
  }

  void routeWalletPage(BuildContext context) {
    Routers.instance.pushNamed(context, Routers.dashboardPath);
  }

  void routeSignInPage(BuildContext context) {
    Routers.instance.pushNamed(context, Routers.loginPath);
  }

  Stream? get searchBarStreamController => _searchBarStreamController.stream;
  Stream get getEmptyStream => const Stream.empty(broadcast: true);
  // we will get stream after ensure connection is done !
}

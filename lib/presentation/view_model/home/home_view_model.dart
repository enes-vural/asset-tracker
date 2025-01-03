import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../data/model/web/response/socket_state_response_model.dart';
import '../../../domain/entities/web/error/socket_error_entity.dart';

class HomeViewModel extends ChangeNotifier {
  GetSocketStreamUseCase getSocketStreamUseCase;

  HomeViewModel({required this.getSocketStreamUseCase});

  Future<void> getData() async {
    final data = await getSocketStreamUseCase.call(null);
    debugPrint(data.toString());
    data.fold((failure) => debugPrint(failure.message), (success) {
      debugPrint("Connection STATE : ${success.state}");
    });
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

  Stream<dynamic>? getStream() {
    return getSocketStreamUseCase.getDataStream();
  }

  // we will get stream after ensure connection is done !
}
//test@gmail.com

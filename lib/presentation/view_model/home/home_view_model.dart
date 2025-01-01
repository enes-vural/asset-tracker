import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  GetSocketStreamUseCase getSocketStreamUseCase;

  HomeViewModel({required this.getSocketStreamUseCase});

  Future<void> getData() async {
    final data = await getSocketStreamUseCase.call(null);
    debugPrint(data.toString());
    data.fold((failure) => print(failure.message), (success) {
      debugPrint("Connection STATE : " + success.state.toString());
    });
  }

  Future<void> getErrorStream() async {
    final data = getSocketStreamUseCase.getErrorStream();
    data?.listen((event) {
      debugPrint("ENES HATA : : " + event.toString());
    });
  }

  Stream<dynamic>? getStream() {
    return getSocketStreamUseCase.getDataStream();
  }

  // we will get stream after ensure connection is done !
}
//test@gmail.com

import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  GetSocketStreamUseCase getSocketStreamUseCase;

  HomeViewModel({required this.getSocketStreamUseCase});

  Future<void> getData() async {
    final data = await getSocketStreamUseCase.call(null);
    print(data.toString());
    data.fold((failure) => print(failure.message), (success) {
      print("Connection STATE : " + success.state.toString());
    }
    );
  }

  // we will get stream after ensure connection is done !
}
//test@gmail.com

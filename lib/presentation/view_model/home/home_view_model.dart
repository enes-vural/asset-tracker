import 'package:asset_tracker/data/repository/web/iweb_socket_repository.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  IWebSocketRepository service;

  HomeViewModel({required this.service});

  Future<void> getData() async {
    await service.startConnection();
  }
}
//test@gmail.com

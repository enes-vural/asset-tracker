import 'dart:async';

import 'package:asset_tracker/data/model/web/response/socket_state_response_model.dart';
import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';
import 'package:asset_tracker/domain/usecase/base/base_use_case.dart';
import 'package:dartz/dartz.dart';
import '../../entities/web/error/socket_error_entity.dart';
import '../../repository/web/iweb_socket_repository.dart';

class GetSocketStreamUseCase implements BaseUseCase {
  final IWebSocketRepository _webRepository;

  GetSocketStreamUseCase(this._webRepository);

  @override
  Future<Either<BaseErrorEntity, SocketStateResponseModel>> call(params) async {
    return await _webRepository.startConnection();
  }

  Stream<dynamic>? getDataStream() {
    return _webRepository.stream?.asBroadcastStream();
  }

  Stream<Either<SocketErrorEntity, SocketStateResponseModel>>?
      getErrorStream() {
    return _webRepository.errorStream;
  }

  Future<void> closeSocket() async {
    await _webRepository.closeStream();
  }

  StreamController? get controller => _webRepository.controller;

  StreamController? get errorController => _webRepository.errorController;

}

import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../data/model/web/response/socket_state_response_model.dart';
import '../../../domain/entities/web/error/socket_error_entity.dart';

abstract interface class IWebSocketRepository {
  Future<Either<SocketErrorEntity, SocketStateResponseModel>> startConnection();

  Stream? get stream;
  Stream<Either<SocketErrorEntity, SocketStateResponseModel>>? get errorStream;

  StreamController? get errorController;

  StreamController? get controller;

  Future<void> closeStream();
}

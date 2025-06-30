import 'package:asset_tracker/core/constants/enums/socket/socket_state_enums.dart';

class SocketStateResponseModel {
  final String message;
  final SocketStateEnum state;

  const SocketStateResponseModel(
    this.message,
    this.state,
  );
}

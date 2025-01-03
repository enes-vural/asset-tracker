import 'package:asset_tracker/data/model/base/error/error_model.dart';

import '../response/socket_state_response_model.dart';

class SocketErrorModel extends BaseErrorModel {
  // şu anlık bir enum ile state belirtmeyeceğim
  final SocketStateEnum state;
  const SocketErrorModel({required super.message, required this.state});
}

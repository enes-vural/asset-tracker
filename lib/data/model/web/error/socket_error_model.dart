import 'package:asset_tracker/core/constants/enums/socket/socket_state_enums.dart';
import 'package:asset_tracker/data/model/base/error/error_model.dart';
class SocketErrorModel extends BaseErrorModel {
  // şu anlık bir enum ile state belirtmeyeceğim
  final SocketStateEnum state;
  const SocketErrorModel({required super.message, required this.state});
}

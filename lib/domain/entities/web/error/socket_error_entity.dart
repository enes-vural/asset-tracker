import 'package:asset_tracker/data/model/web/error/socket_error_model.dart';
import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';

import '../../../../data/model/web/response/socket_state_response_model.dart';

class SocketErrorEntity extends BaseErrorEntity {
  final SocketStateEnum state;
  SocketErrorEntity({required super.message, required this.state});
  //super can not take const

  factory SocketErrorEntity.fromModel(SocketErrorModel model) {
    return SocketErrorEntity(
        message: model.message.toString(), state: model.state);
  }
}

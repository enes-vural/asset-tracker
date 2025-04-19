import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';


final class OfflineActionsModel<T> {
  final OfflineActionType type;
  final OfflineActionStatus status;
  final T params;

  const OfflineActionsModel({
    required this.type,
    required this.status,
    required this.params,
  });

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'type': type.name,
      'status': status.name,
      'params': toJsonT(params),
    };
  }

  factory OfflineActionsModel.fromJson(
    Map<dynamic, dynamic> json,
  ) {
    final params = _getParamFromJson(json['type'], json['params']);

    return OfflineActionsModel(
      type: OfflineActionType.values.firstWhere((e) => e.name == json['type']),
      status: OfflineActionStatus.values
          .firstWhere((e) => e.name == json['status']),
      params: params,
    );
  }

  static _getParamFromJson(String? type, Map<dynamic, dynamic> params) {
    return switch (type) {
      'LOGIN' => UserLoginModel.fromJson(Map<String, dynamic>.from(params)),
      'REGISTER' =>
        UserRegisterModel.fromJson(Map<String, dynamic>.from(params)),
      _ => null,
    };
  }
}

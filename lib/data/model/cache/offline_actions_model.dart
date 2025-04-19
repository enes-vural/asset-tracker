import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';
import 'package:asset_tracker/data/service/cache/hive_cache_service.dart';

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
    Map<String, dynamic> json,
  ) {
    final dynamic params = switch (json['type']) {
      'LOGIN' => UserLoginModel.fromJson(json['params']),
      'REGISTER' => UserRegisterModel.fromJson(json['params']),
      _ => null,
    };

    return OfflineActionsModel(
      type: OfflineActionType.values.firstWhere((e) => e.name == json['type']),
      status: OfflineActionStatus.values
          .firstWhere((e) => e.name == json['status']),
      params: params,
    );
  }
}

import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';
import 'package:asset_tracker/data/model/database/request/buy_currency_model.dart';

final class OfflineActionsModel<T> {
  final String id;
  final OfflineActionType type;
  final OfflineActionStatus status;
  final T params;

  const OfflineActionsModel({
    required this.id,
    required this.type,
    required this.status,
    required this.params,
  });

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'id': id,
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
      id: json['id'] ?? '',
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
      'BUY_ASSET' =>
        BuyCurrencyModel.fromJson(Map<String, dynamic>.from(params)),
      _ => null,
    };
  }

  //copyWith
  OfflineActionsModel<T> copyWith({
    String? id,
    OfflineActionType? type,
    OfflineActionStatus? status,
    T? params,
  }) {
    return OfflineActionsModel<T>(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      params: params ?? this.params,
    );
  }
}

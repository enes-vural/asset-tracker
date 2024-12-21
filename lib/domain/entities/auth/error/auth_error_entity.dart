import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/data/model/auth/error/auth_response_model.dart';
import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';

class AuthErrorEntity extends BaseErrorEntity {
  AuthErrorEntity({required super.message});

  factory AuthErrorEntity.fromModel(AuthErrorModel errorModel) {
    return AuthErrorEntity(
      message: errorModel.message ?? DefaultLocalStrings.emptyText,
    );
  }
}

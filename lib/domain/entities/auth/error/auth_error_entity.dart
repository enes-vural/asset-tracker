import 'package:asset_tracker/core/constants/enums/auth/auth_error_state_enums.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/data/model/auth/error/auth_response_model.dart';
import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';

class AuthErrorEntity extends BaseErrorEntity {
  final AuthErrorState state;
  AuthErrorEntity(this.state, {required super.message});

  factory AuthErrorEntity.fromModel(AuthErrorModel errorModel) {
    return AuthErrorEntity(
      errorModel.errorState ?? AuthErrorState.GENERAL_ERR,
      message: errorModel.message ?? DefaultLocalStrings.emptyText,
    );
  }
}

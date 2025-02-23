import 'package:asset_tracker/data/model/database/error/database_error_model.dart';
import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';

final class DatabaseErrorEntity extends BaseErrorEntity {
  const DatabaseErrorEntity({required super.message});

  factory DatabaseErrorEntity.fromModel(DatabaseErrorModel model) {
    return DatabaseErrorEntity(message: model.message.toString());
  }
}

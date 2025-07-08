import 'package:asset_tracker/domain/entities/auth/base/error/base_error_entity.dart';
import 'package:asset_tracker/domain/repository/messaging/imessaging_repository.dart';
import 'package:asset_tracker/domain/usecase/base/base_use_case.dart';
import 'package:dartz/dartz.dart';

class NotificationUseCase implements BaseUseCase {
  final IMessagingRepository _messagingRepository;

  NotificationUseCase(this._messagingRepository);

  @override
  Future<Either<BaseErrorEntity, dynamic>> call(params) {
    throw UnimplementedError();
  }

  Future<String?> getUserToken() async {
    return await _messagingRepository.getToken();
  }

  Future<bool> isPermissionAuthorized() async {
    return await _messagingRepository.isAuthorized();
  }
}

import 'package:asset_tracker/data/service/remote/messaging/imessaging_service.dart';
import 'package:asset_tracker/domain/repository/messaging/imessaging_repository.dart';

final class FirebaseMessagingRepository implements IMessagingRepository {
  final IMessagingService messagingService;

  FirebaseMessagingRepository({required this.messagingService});

  @override
  Future<String?> getToken() async {
    return await messagingService.getToken();
  }

  @override
  Future<void> initialize() async {
    return await messagingService.initialize();
  }

  @override
  Future<bool> isAuthorized() async {
    return await messagingService.isAuthorized();
  }
}

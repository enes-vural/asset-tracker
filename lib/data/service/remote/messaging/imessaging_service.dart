abstract interface class IMessagingService {
  Future<void> initialize();

  Future<bool> isAuthorized();

  Future<String?> getToken();
}

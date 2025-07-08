abstract interface class IMessagingRepository {
  Future<void> initialize();

  Future<bool> isAuthorized();

  Future<String?> getToken();
}

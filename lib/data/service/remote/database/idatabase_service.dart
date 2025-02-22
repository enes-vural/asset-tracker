abstract interface class IDatabaseService {
  Future<void> buyCurrency();

  Future<void> sellCurrency();
}

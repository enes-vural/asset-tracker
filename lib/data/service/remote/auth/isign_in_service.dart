abstract interface class ISignInService<TSignInAccount> {
  Future<void> initialize();

  Future<TSignInAccount?> signIn();

  Future<void> signOut();
}

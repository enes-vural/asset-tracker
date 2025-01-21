final class AuthTestCasesModel {
  final String email;
  final String password;
  final String expectedMessage;

  const AuthTestCasesModel({
    required this.email,
    required this.password,
    required this.expectedMessage,
  });
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_service_shared.mocks.dart';

@GenerateMocks([FirebaseAuth, User, UserCredential])
class MockAuthHelper {
  final String wrongEmail = "wrongemail@.com";
  final String correctEmail = "correct@gmail.com";
  final String wrongPassword = "123";
  final String correctPassword = "123456";

  MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  late MockUser _mockUser;
  late MockUserCredential _userCredential;
  //late FirebaseAuthService _authService;

  MockAuthHelper() {
    _mockUser = MockUser();
    //_authService = FirebaseAuthService(authService: mockFirebaseAuth);
    _userCredential = MockUserCredential();
  }

  //FirebaseAuthService get service => _authService;
  MockUser get user => _mockUser;
  MockUserCredential get userCreds => _userCredential;

  void whenSuccessLogin(String email, String password) {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed("email"), password: anyNamed("password")))
        .thenAnswer((_) async => _userCredential);
  }

  void whenSuccessCredAndToken() async {
    when(_userCredential.user).thenReturn(_mockUser);
    when(_mockUser.uid).thenReturn('success-credential');
    when(_mockUser.getIdToken()).thenAnswer((_) async => "success-token");
  }

  void whenFailedLogin(String email, String password) {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed("email"), password: anyNamed("password")))
        .thenThrow(Exception("Invalid Credentials"));
  }
}

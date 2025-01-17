import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/data/service/remote/auth/auth_service.dart';
import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'auth_test.mocks.dart';

@GenerateMocks([FirebaseAuth, User, UserCredential])
final class MockValidationMixin extends Mock implements ValidatorMixin {}

void main() {
  //github copilot 10 dolar olmuş
  //pro üyelikte bile 2k kotadan sonra kullanmama izin vermezse bu repo daha ilerlemez.
  //ona göre ayağınızı denk alın

  late MockFirebaseAuth mockFirebaseAuth;
  late FirebaseAuthService authService;
  late MockValidationMixin mockValidationMixin;

  const String wrongEmail = "wrongemail@.com";
  const String correctEmail = "correct@gmail.com";
  const String wrongPassword = "123";
  const String correctPassword = "123456";

  group('Auth Service', () {
    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authService = FirebaseAuthService(authService: mockFirebaseAuth);
      mockValidationMixin = MockValidationMixin();
    });

    test("Succesfull Login Test", () async {
      final MockUser mockUser = MockUser();
      final mockUserCredential = MockUserCredential();

      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => mockUserCredential);

      when(mockUser.uid).thenReturn("test-uid-passes");

      when(mockUserCredential.user).thenReturn(mockUser);

      when(mockUser.displayName).thenReturn("Test User");

      final loginResult = await authService.signInUser(const UserLoginEntity(
          userName: "test@gmail.com", password: "123456"));

      final user = loginResult?.user;

      final displayNameResult = user?.displayName;

      final String? testUid = user?.uid;

      expect(loginResult, mockUserCredential);
      expect(user, mockUser);
      expect(displayNameResult, "Test User");
      expect(testUid, "test-uid-passes");
    });

    test("Login Failed Test", () {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(Exception("Invalid Credentials"));

      final loginResult = authService.signInUser(const UserLoginEntity(
          userName: "email@gmail.com", password: "wrong-password"));

      expect(() => loginResult, throwsException);
    });

    test("Email Validation Test", () {
      //burada type

      when(mockValidationMixin.checkEmail(wrongEmail))
          .thenReturn("Invalid-Email");
      when(mockValidationMixin.checkEmail("")).thenReturn("Empty-Email");

      final wrongEmailResult = mockValidationMixin.checkEmail(wrongEmail);
      final emptyEmailResult = mockValidationMixin.checkEmail("");
      final correctEmailResult = mockValidationMixin.checkEmail(correctEmail);

      expect(wrongEmailResult, "Invalid-Email");
      expect(emptyEmailResult, "Empty-Email");
      expect(correctEmailResult, null);
    });

    test("Password Validation Test", () {
      when(mockValidationMixin.checkPassword(wrongPassword))
          .thenReturn("Weak-Password");
      when(mockValidationMixin.checkPassword("")).thenReturn("Empty-Password");

      final wrongPasswordResult =
          mockValidationMixin.checkPassword(wrongPassword);

      final emptyPasswordResult = mockValidationMixin.checkPassword("");
      final correctPasswordResult =
          mockValidationMixin.checkPassword(correctPassword);

      expect(wrongPasswordResult, "Weak-Password");
      expect(emptyPasswordResult, "Empty-Password");
      expect(correctPasswordResult, null);
    });
  });
}

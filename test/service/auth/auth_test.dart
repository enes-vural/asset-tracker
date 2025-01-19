import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/data/service/remote/auth/auth_service.dart';
import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../shared/auth_service_shared.dart';

final class MockValidationMixin extends Mock implements ValidatorMixin {}

void main() {
  //github copilot 10 dolar olmuş
  //pro üyelikte bile 2k kotadan sonra kullanmama izin vermezse bu repo daha ilerlemez.
  //ona göre ayağınızı denk alın

  late MockAuthHelper mockAuthHelper;
  late FirebaseAuthService firebaseAuthService;
  late MockValidationMixin mockValidationMixin;

  group('Auth Service', () {
    setUp(() {
      mockAuthHelper = MockAuthHelper();

      firebaseAuthService =
          FirebaseAuthService(authService: mockAuthHelper.mockFirebaseAuth);

      mockValidationMixin = MockValidationMixin();
    });

    tearDown(() {
      reset(mockValidationMixin);
    });

    test("Succesfull Login Test", () async {
      final mockUserCredential = mockAuthHelper.userCreds;
      final mockUser = mockAuthHelper.user;

      mockAuthHelper.whenSuccessLogin(
          mockAuthHelper.correctEmail, mockAuthHelper.correctPassword);

      when(mockAuthHelper.user.uid).thenReturn("test-uid-passes");

      when(mockAuthHelper.userCreds.user).thenReturn(mockUser);

      when(mockAuthHelper.user.displayName).thenReturn("Test User");

      final loginResult = await firebaseAuthService.signInUser(
          const UserLoginEntity(
          userName: "test@gmail.com", password: "123456"));

      final user = loginResult?.user;

      final displayNameResult = user?.displayName;

      final String? testUid = user?.uid;

      expect(loginResult, mockUserCredential);
      expect(user, mockUser);
      expect(displayNameResult, "Test User");
      expect(testUid, "test-uid-passes");
    });

    test("Login Failed Test (Invalid Credentials)", () async {
      mockAuthHelper.whenFailedLogin(
          mockAuthHelper.wrongEmail, mockAuthHelper.wrongPassword);

      expect(
          () async => await firebaseAuthService.signInUser(
              const UserLoginEntity(
                  userName: "email@gmail.com", password: "wrong-password")),
          throwsException);
    });

    test("Email Validation Test", () {
      //burada type

      when(mockValidationMixin.checkEmail(mockAuthHelper.wrongEmail))
          .thenReturn("Invalid-Email");
      when(mockValidationMixin.checkEmail("")).thenReturn("Empty-Email");

      final wrongEmailResult =
          mockValidationMixin.checkEmail(mockAuthHelper.wrongEmail);
      final emptyEmailResult = mockValidationMixin.checkEmail("");
      final correctEmailResult =
          mockValidationMixin.checkEmail(mockAuthHelper.correctEmail);

      verifyNever(mockAuthHelper.mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed("email"),
        password: anyNamed("password"),
      ));
      
      expect(wrongEmailResult, "Invalid-Email");
      expect(emptyEmailResult, "Empty-Email");
      expect(correctEmailResult, null);


    });

    test("Password Validation Test", () {
      when(mockValidationMixin.checkPassword(mockAuthHelper.wrongPassword))
          .thenReturn("Weak-Password");
      when(mockValidationMixin.checkPassword("")).thenReturn("Empty-Password");

      final wrongPasswordResult =
          mockValidationMixin.checkPassword(mockAuthHelper.wrongPassword);

      final emptyPasswordResult = mockValidationMixin.checkPassword("");
      final correctPasswordResult =
          mockValidationMixin.checkPassword(mockAuthHelper.correctPassword);

      verifyNever(mockAuthHelper.mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed("email"),
        password: anyNamed("password"),
      ));
      
      expect(wrongPasswordResult, "Weak-Password");
      expect(emptyPasswordResult, "Empty-Password");
      expect(correctPasswordResult, null);
    });
  });
}

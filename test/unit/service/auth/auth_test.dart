import 'package:asset_tracker/core/mixins/validation_mixin.dart';
import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/service/remote/auth/firebase_auth_service.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_login_entity.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../shared/auth_service_shared.dart';
import '../../shared/constants/test_constants.dart';

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
      const userEntity =
          UserLoginEntity(userName: "test@gmail.com", password: "123456");

      final mockUser = mockAuthHelper.user;

      mockAuthHelper.whenSuccessLogin(
          TestConstants.correctEmail, TestConstants.correctPassword);

      mockAuthHelper.whenSuccessCredAndToken();

      final FirebaseAuthUser? loginResult =
          await firebaseAuthService
          .signInUser(UserLoginModel.fromEntity(userEntity));

      final user = loginResult?.user;
      final displayNameResult = user?.displayName;
      final String? testUid = user?.uid;
      final String? idToken = await user?.getIdToken();

      expect(user, mockUser);
      expect(displayNameResult, "Test User");
      expect(testUid, "success-credential");
      expect(idToken, "test-id-token");
    });

    test("Login Failed Test (Invalid Credentials)", () async {
      mockAuthHelper.whenFailedLogin(
          TestConstants.wrongEmail, TestConstants.wrongPassword);

      expect(
          () async => await firebaseAuthService.signInUser(
              UserLoginModel.fromEntity(const UserLoginEntity(
                  userName: "email@gmail.com", password: "wrong-password"))),
          throwsException);
    });

    test("Email Validation Test", () {
      //burada type

      when(mockValidationMixin.checkEmail(TestConstants.wrongEmail))
          .thenReturn("Invalid-Email");
      when(mockValidationMixin.checkEmail("")).thenReturn("Empty-Email");

      final wrongEmailResult =
          mockValidationMixin.checkEmail(TestConstants.wrongEmail);
      final emptyEmailResult = mockValidationMixin.checkEmail("");
      final correctEmailResult =
          mockValidationMixin.checkEmail(TestConstants.correctEmail);

      verifyNever(mockAuthHelper.mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed("email"),
        password: anyNamed("password"),
      ));

      expect(wrongEmailResult, "Invalid-Email");
      expect(emptyEmailResult, "Empty-Email");
      expect(correctEmailResult, null);
    });

    test("Password Validation Test", () {
      when(mockValidationMixin.checkPassword(TestConstants.wrongPassword))
          .thenReturn("Weak-Password");
      when(mockValidationMixin.checkPassword("")).thenReturn("Empty-Password");

      final wrongPasswordResult =
          mockValidationMixin.checkPassword(TestConstants.wrongPassword);

      final emptyPasswordResult = mockValidationMixin.checkPassword("");
      final correctPasswordResult =
          mockValidationMixin.checkPassword(TestConstants.correctPassword);

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

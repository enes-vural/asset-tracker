import 'package:asset_tracker/data/repository/auth/auth_repository.dart';
import 'package:asset_tracker/data/service/remote/auth/auth_service.dart';
import 'package:asset_tracker/data/service/remote/auth/iauth_service.dart';
import 'package:asset_tracker/domain/entities/auth/error/auth_error_entity.dart';
import 'package:asset_tracker/domain/entities/auth/user_login_response_entity.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../shared/auth_service_shared.dart';
import '../../shared/constants/test_constants.dart';

void main() {
  late MockAuthHelper mockAuthHelper;
  late IAuthService firebaseAuthService;
  late IAuthRepository authRepo;

  setUpAll(() {
    //   FlutterError.onError = (details) {
    //   if (details.exception is FlutterError && details.exception.toString().contains("auth.response.generalErr")) {
    //     // Bu tür uyarıları yok say
    //     return;
    //   }
    //   // Diğer hataları normal şekilde işleyin
    //   FlutterError.dumpErrorToConsole(details);
    // };
    // [Level.SEVERE, Level.SHOUT];
    EasyLocalization.logger.enableLevels = [];
  });

  setUp(() {
    mockAuthHelper = MockAuthHelper();
    firebaseAuthService =
        FirebaseAuthService(authService: mockAuthHelper.mockFirebaseAuth);

    authRepo = FirebaseAuthRepository(authService: firebaseAuthService);
  });

  group("Authentication Repository (Data)", () {
    test("Authentication Repository Success Test", () async {
      mockAuthHelper.whenSuccessLogin(TestConstants.successLoginEntity.userName,
          TestConstants.successLoginEntity.password);

      when(mockAuthHelper.userCreds.user).thenReturn(mockAuthHelper.user);
      when(mockAuthHelper.user.uid).thenReturn('success-credential');
      when(mockAuthHelper.user.getIdToken())
          .thenAnswer((_) async => "success-token");

      final signInResult =
          await authRepo.signIn(TestConstants.successLoginEntity);

      expect(signInResult, isA<Right<void, UserLoginResponseEntity>>());
      signInResult.fold((_) => fail("Expected Right but got left"),
          (right) => expect(right.token, "success-token"));
    });

    test("Authentication Repository Failed (User not found) Test", () async {
      mockAuthHelper.whenFailedLogin(TestConstants.successLoginEntity.userName,
          TestConstants.successLoginEntity.password);
      when(mockAuthHelper.userCreds.user?.uid).thenReturn(null);

      final signInResult =
          await authRepo.signIn(TestConstants.successLoginEntity);

      expect(signInResult, isA<Left<AuthErrorEntity, void>>());
    });
  });
}

import 'package:asset_tracker/core/constants/enums/auth/auth_error_state_enums.dart';
import 'package:asset_tracker/data/repository/auth/firebase_auth_email_repository.dart';
import 'package:asset_tracker/domain/entities/auth/error/auth_error_entity.dart';
import 'package:asset_tracker/domain/entities/auth/response/user_login_response_entity.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../shared/constants/test_constants.dart';
import 'usecase_test.mocks.dart';

@GenerateMocks([FirebaseAuthEmailRepository])
void main() {
  late IEmailAuthRepository firebaseAuthRepository;

  late AuthUseCase authUseCase;
  setUp(() {
    firebaseAuthRepository = MockFirebaseAuthEmailRepository();
    authUseCase = AuthUseCase(firebaseAuthRepository);
  });
  group("Authentication Use Case Group", () {
    test("Sign In Use Case Success", () async {
      when(firebaseAuthRepository.signIn(TestConstants.successLoginEntity))
          .thenAnswer((_) async =>
              Right(UserLoginResponseEntity(uid: "success-token")));

      final result = await authUseCase.call(TestConstants.successLoginEntity);

      expect(result, isA<Right<void, UserLoginResponseEntity>>());
      result.fold((_) => fail("Expected Right but got Left"),
          (succcess) => expect(succcess.uid, "success-token"));
    });

    test("Sign In Use Case Failed", () async {
      when(firebaseAuthRepository.signIn(TestConstants.failureLoginEntity))
          .thenAnswer(
              (_) async => Left(AuthErrorEntity(
              AuthErrorState.NOT_FOUND,
              message: "User not found")));

      final result = await authUseCase.call(TestConstants.failureLoginEntity);

      expect(result, isA<Left<AuthErrorEntity, void>>());
      result.fold((testDone) => expect(testDone.message, "User not found"),
          (_) => fail("Expected Left but got Right"));
      // Assert
    });
  });
}

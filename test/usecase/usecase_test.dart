import 'package:asset_tracker/data/repository/auth/auth_repository.dart';
import 'package:asset_tracker/domain/entities/auth/error/auth_error_entity.dart';
import 'package:asset_tracker/domain/entities/auth/user_login_response_entity.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../shared/constants/test_constants.dart';
import 'usecase_test.mocks.dart';

@GenerateMocks([FirebaseAuthRepository])
void main() {
  late MockFirebaseAuthRepository firebaseAuthRepository;

  late SignInUseCase signInUseCase;
  setUp(() {
    firebaseAuthRepository = MockFirebaseAuthRepository();
    signInUseCase = SignInUseCase(firebaseAuthRepository);
  });
  group("Authentication Use Case Group", () {
    test("Sign In Use Case Success", () async {
      when(firebaseAuthRepository.signIn(TestConstants.successLoginEntity))
          .thenAnswer((_) async =>
              Right(UserLoginResponseEntity(token: "success-token")));

      final result = await signInUseCase.call(TestConstants.successLoginEntity);

      expect(result, isA<Right<void, UserLoginResponseEntity>>());
      result.fold(
          (_) => null, (succcess) => expect(succcess.token, "success-token"));
    });

    test("Sign In Use Case Failed", () async {
      when(firebaseAuthRepository.signIn(TestConstants.failureLoginEntity))
          .thenAnswer(
              (_) async => Left(AuthErrorEntity(message: "User not found")));

      final result = await signInUseCase.call(TestConstants.failureLoginEntity);

      expect(result, isA<Left<AuthErrorEntity, void>>());
      result.fold(
          (failure) => expect(failure.message, "User not found"), (_) => null);
      // Assert
    });
  });
}

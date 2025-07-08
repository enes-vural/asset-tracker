import 'package:asset_tracker/core/constants/enums/auth/auth_error_state_enums.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/data/model/auth/error/auth_response_model.dart';
import 'package:asset_tracker/data/model/auth/iauth_user_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';
import 'package:asset_tracker/data/model/auth/response/user_login_response_model.dart';
import 'package:asset_tracker/data/repository/auth/base/base_auth_repository.dart';
import 'package:asset_tracker/data/service/remote/auth/iauth_service.dart';
import 'package:asset_tracker/domain/entities/auth/error/auth_error_entity.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_login_entity.dart';
import 'package:asset_tracker/domain/entities/auth/request/user_register_entity.dart';
import 'package:asset_tracker/domain/entities/auth/response/user_login_response_entity.dart';
import 'package:asset_tracker/domain/entities/auth/response/user_register_reponse_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

class FirebaseAuthEmailRepository implements IEmailAuthRepository {
  final IAuthService authService;
  final BaseAuthRepository baseAuthRepository;

  FirebaseAuthEmailRepository({
    required this.authService,
    required this.baseAuthRepository,
  });

  @override
  Future<Either<AuthErrorEntity, UserLoginResponseEntity>> signIn(
      UserLoginEntity entity) async {
    try {
      IAuthenticationUserModel? userResponse =
          await authService.signInUser(UserLoginModel.fromEntity(entity));

      if (userResponse?.uid != null) {
        final String? userUid = userResponse?.uid;
        final UserLoginResponseModel userModel = UserLoginResponseModel(
            uid: userUid ?? DefaultLocalStrings.emptyText);

        UserLoginResponseEntity userEntity =
            UserLoginResponseEntity.fromModel(userModel);
        return Right(userEntity);

        //Firstly we get the data check validate and convert it to model
        //after that we converted it to entity for our domain layer
        //let's return => => =>
      } else {
        return Left(AuthErrorEntity.fromModel(
            AuthErrorModel(errorState: AuthErrorState.INVALID_CRED)));
      }

      //
      //  EXCEPTION CHECKS IN BELOW
      //
    } on FirebaseException catch (error) {
      //check firebase errors
      //convert it to entity before return
      return Left(
          AuthErrorEntity.fromModel(AuthErrorModel.fromErrorCode(error.code)));
      //
    } catch (e) {
      //check general errors
      //convert it to entity before return
      //aksi durumda direkt general error ver
      return Left(AuthErrorEntity.fromModel(
          AuthErrorModel.fromErrorCode(AuthErrorState.GENERAL_ERR.value)));
      //
    }
  }

  @override
  Future<Either<AuthErrorEntity, UserRegisterReponseEntity>> registerUser(
      UserRegisterEntity entity) async {
    final defaultErr = AuthErrorEntity.fromModel(
        AuthErrorModel(errorState: AuthErrorState.GENERAL_ERR));

    try {
      final UserCredential? response =
          await authService.registerUser(UserRegisterModel.fromEntity(entity));

      if (response == null) {
        return Left(defaultErr);
      }
      return Right(
        UserRegisterReponseEntity(
            password: entity.password,
            uid: response.user?.uid ?? DefaultLocalStrings.emptyText,
            userName: response.user?.email ?? DefaultLocalStrings.emptyText),
      );
    } on FirebaseException catch (error) {
      if (error.code == AuthErrorState.NETWORK_ERROR.value) {
        //TODO:
        //Offline First
      }
      return Left(
          AuthErrorEntity.fromModel(AuthErrorModel.fromErrorCode(error.code)));
    }
  }

  @override
  String? getUserId() {
    return baseAuthRepository.getUserId();
  }

  @override
  Stream getUserStateChanges() {
    return baseAuthRepository.getUserStateChanges();
  }

  @override
  Future<void> signOut() async {
    return await baseAuthRepository.signOut();
  }

  @override
  Future<void> sendResetPasswordLink(String email) async {
    return await authService.sendResetPasswordLink(email);
  }

  @override
  Future<Either<AuthErrorEntity, bool>> deleteAccount() async {
    return await baseAuthRepository.deleteAccount();
  }

  @override
  Future<Either<DatabaseErrorEntity, bool>> sendEmailVerification() async {
    return await baseAuthRepository.sendEmailVerification();
  }
}

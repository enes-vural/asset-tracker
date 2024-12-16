import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/data/model/auth/error/auth_error_state.dart';
import 'package:asset_tracker/data/model/auth/error/auth_response_model.dart';
import 'package:asset_tracker/data/model/auth/response/user_login_response_model.dart';
import 'package:asset_tracker/data/service/remote/auth/auth_service.dart';
import 'package:asset_tracker/domain/entities/auth/error/auth_error_entity.dart';
import 'package:asset_tracker/domain/entities/auth/user_login_entity.dart';
import 'package:asset_tracker/domain/entities/auth/user_login_response_entity.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuthService authService;

  AuthRepository({required this.authService});

  @override
  Future<Either<AuthErrorEntity, UserLoginResponseEntity>> signIn(
      UserLoginEntity entity) async {
    try {
      UserCredential? userResponse = await authService.signInUser(entity);

      if (userResponse?.user?.uid != null) {
        final UserLoginResponseModel userModel = UserLoginResponseModel(
            token: userResponse!.credential?.token.toString() ??
                DefaultLocalStrings.emptyText);

        UserLoginResponseEntity userEntity =
            UserLoginResponseEntity.fromModel(userModel);
        return Right(userEntity);

        //Firstly we get the data check validate and convert it to model
        //after that we converted it to entity for our domain layer
        //let's return => => =>
      } else {
        return Left(AuthErrorEntity.fromModel(
            AuthErrorModel(errorCode: AuthErrorState.INVALID_CRED.value)));
      }

      //
      //  EXCEPTION CHECKS IN BELOW
      //
    } on FirebaseException catch (error) {
      //check firebase errors
      //convert it to entity before return
      return Left(AuthErrorEntity.fromModel(
          AuthErrorModel.toErrorModel(error.code)));
      //
    } catch (e) {
      //check general errors
      //convert it to entity before return
      //aksi durumda direkt general error ver
      return Left(AuthErrorEntity.fromModel(
          AuthErrorModel.toErrorModel(AuthErrorState.GENERAL_ERR.value)));
      //
    }
  }
}

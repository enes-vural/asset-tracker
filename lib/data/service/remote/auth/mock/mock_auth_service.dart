import 'package:asset_tracker/data/model/auth/error/auth_response_model.dart';
import 'package:asset_tracker/data/model/auth/mock_auth_user_model.dart';
import 'package:asset_tracker/data/model/auth/mock_user_credentinal.dart';
import 'package:asset_tracker/data/model/auth/request/user_login_model.dart';
import 'package:asset_tracker/data/model/auth/request/user_register_model.dart';
import 'package:asset_tracker/data/model/database/error/database_error_model.dart';
import 'package:asset_tracker/data/service/remote/auth/mock/imock_auth_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

//MockAuthService sınıfı IAuthService sınıfını implemente eder.
//Otomatik olarak 1 saniye sonra gerekli parametreleri içeren mock sınıfını döndürür.

class MockAuthService implements IMockAuthService {
  @override
  Future<MockAuthUserModel>? signInUser(UserLoginModel model) {
    if (model.userName != "test@gmail.com" && model.password != "123456") {
      return null;
    }
    final mockUserCreds = _correctModel(model);
    return Future.delayed(const Duration(seconds: 1), () => mockUserCreds);
  }

  MockAuthUserModel _correctModel(UserLoginModel entity) {
    return MockAuthUserModel(
        email: entity.userName,
        uid: "123456",
        emailVerified: true,
        displayName: "Test User",
        idToken: "Test-User-ID-Token_SUCCESS");
  }

  @override
  String? getUserId() {
    return "mock-user-id";
  }

  @override
  Stream getUserStateChanges() {
    throw const Stream.empty();
  }

  @override
  Future<void> signOutUser() {
    debugPrint("Signed out");
    throw UnimplementedError();
  }

  @override
  Future<MockUserCredentinal> registerUser(UserRegisterModel model) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
  
  @override
  Future<void> sendResetPasswordLink(String email) {
    // TODO: implement sendResetPasswordLink
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthErrorModel, bool>> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<Either<DatabaseErrorModel, bool>> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }
}

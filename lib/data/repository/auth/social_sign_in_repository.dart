import 'dart:async';
import 'dart:io';

import 'package:asset_tracker/data/model/auth/firebase_auth_user_model.dart';
import 'package:asset_tracker/data/repository/auth/base/base_auth_repository.dart';
import 'package:asset_tracker/data/service/remote/auth/ifirebase_auth_service.dart';
import 'package:asset_tracker/data/service/remote/auth/isign_in_service.dart';
import 'package:asset_tracker/domain/entities/auth/error/auth_error_entity.dart';
import 'package:asset_tracker/domain/entities/database/error/database_error_entity.dart';
import 'package:asset_tracker/domain/repository/auth/iauth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show debugPrint;

final class SocialAuthRepository implements ISocialAuthRepository {
  final ISignInService googleSignInService;
  final ISignInService appleSignInService;
  final IFirebaseAuthService firebaseAuthService;
  final BaseAuthRepository baseAuthRepository;

  SocialAuthRepository(
    this.googleSignInService,
    this.appleSignInService,
    this.firebaseAuthService,
    this.baseAuthRepository,
  );

  @override
  Future<void> initializeServices() async {
    if (Platform.isIOS) await appleSignInService.initialize();
    await googleSignInService.initialize();
    await _callSignInWithCredential();
  }

  //buradaki _callSignInWithCredential metodu, GoogleSignInAccount parametresi alabilir
  //Bu parametre account parametresi signIn methodundan gecikmesiz döner.
  //Ama account parametresi splash tarafından geliyorsa bu gecikmeli gelebilir bu da
  //error a neden olabilir.
  //Bu yüzden eğer account u signIn tarafından çağırıyorsak state in yenilenmesini beklemeden.
  //SDK dan dönen account u atıyoruz.
  //Eğer account parametresi null ise o zaman splash tarafından çağırılmıştır.
  //Eğer account null ise o zaman googleSignInService.currentUser dan alıyoruz.
  //Eğer o da null ise zaten kullanıcı giriş yapmamıştır.
  Future<FirebaseAuthUser?> _callSignInWithCredential(
      [FirebaseAuthUser? account]) async {
    if (account != null) {
      final credential = _createCredential(account);
      return await firebaseAuthService.signInWithCredential(credential);
    } else {
      FirebaseAuthUser? account = googleSignInService.currentUser;
      if (account == null) {
        return null;
      }
      final credential = _createCredential(account);
      return await firebaseAuthService.signInWithCredential(credential);
    }
  }

  OAuthCredential _createCredential(FirebaseAuthUser authUser) {
    return GoogleAuthProvider.credential(
      idToken: authUser.idToken,
    );
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
  Future<Either<AuthErrorEntity, bool>> deleteAccount() async {
    return await baseAuthRepository.deleteAccount();
  }

  @override
  Future<Either<DatabaseErrorEntity, bool>> sendEmailVerification() async {
    return await baseAuthRepository.sendEmailVerification();
  }

  @override
  Future<FirebaseAuthUser?> signInWithApple() async {
    final account = appleSignInService.signIn();
    //firebase apple sign in service olduğu için tekrar cred ile signin etmeye gerek kalmadı.
    return account;
  }

  @override
  Future<FirebaseAuthUser?> signInWithGoogle() async {
    try {
      final account = await googleSignInService.signIn();
      final authUser = await _callSignInWithCredential(account);
      return authUser;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      return null;
    }
  }
}

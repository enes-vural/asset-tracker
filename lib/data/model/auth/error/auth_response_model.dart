import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/data/model/auth/error/auth_error_state.dart';
import 'package:asset_tracker/data/model/base/error/error_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

//we wont use equatable in here because we have no logic to compare
@immutable
final class AuthErrorModel extends BaseErrorModel {
  final String errorCode;
  const AuthErrorModel({super.message, required this.errorCode});

  factory AuthErrorModel.toErrorModel(String errorCode) {
    //gelen hata mesajından AuthErrorState i almaya çalışıyor
    final AuthErrorState errorState = AuthErrorState.values.firstWhere(
        (state) => state.value == errorCode,
        orElse: () => AuthErrorState.GENERAL_ERR);
    //errorState belirlendikten sonra localize edilmiş hata mesajını almka için _fromErrorToModel çağırılıyor.

    //burada gelen hata kodundan error mesajımızı oluşturuyoruz.
    String message = _fromErrorToModel(errorState);
    //gelen hatayı mesaja çevirip nesneyi tekrar türetiyoruz
    return AuthErrorModel(errorCode: errorCode, message: message);
  }
  //static ama '_' ile erişilemiyor factory methodu uygulanabilsin diye ekledim
  static String _fromErrorToModel(AuthErrorState? error) {
    switch (error) {
      case AuthErrorState.ACCOUNT_EXIST:
        return LocaleKeys.auth_response_accountExist.tr();
      case AuthErrorState.INVALID_CRED:
        return LocaleKeys.auth_response_invalidCred.tr();
      case AuthErrorState.NOT_FOUND:
        return LocaleKeys.auth_response_notFound.tr();
      case AuthErrorState.INVALID_EMAIL:
        return LocaleKeys.auth_response_invalidEmail.tr();
      case AuthErrorState.REQUEST_QUOTA:
        return LocaleKeys.auth_response_requestQuotaExceed.tr();
      case AuthErrorState.TIMEOUT:
        return LocaleKeys.auth_response_timeout.tr();
      case AuthErrorState.USER_DISABLED:
        return LocaleKeys.auth_response_userDisabled.tr();
      case AuthErrorState.WRONG_PASSWORD:
        return LocaleKeys.auth_response_wrongPassword.tr();
      default:
        return LocaleKeys.auth_response_generalErr.tr();
    }
  }

  AuthErrorModel copyWith({
    String? message,
    String? errorCode,
  }) {
    return AuthErrorModel(
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}

import 'package:asset_tracker/core/config/theme/extension/auth_error_extension.dart';
import 'package:asset_tracker/data/model/auth/error/auth_error_state.dart';
import 'package:asset_tracker/data/model/base/error/error_model.dart';
import 'package:flutter/material.dart';

//we wont use equatable in here because we have no logic to compare
@immutable
final class AuthErrorModel extends BaseErrorModel {
  final String errorCode;
  const AuthErrorModel({super.message, required this.errorCode});

  factory AuthErrorModel.toErrorModel(String errorCode) {
    //error code a göre authErrorState enum u buluyor.
    final AuthErrorState errorState = errorCode.searchErrorState(errorCode);

    //errorCode Enum Type ına göre içindeki değeri (Localize edilmiş hata mesajını alıyor)
    String message = errorState.fromErrorToModel();
    //gelen hatayı mesaja çevirip nesneyi tekrar türetiyoruz
    return AuthErrorModel(errorCode: errorCode, message: message);
  }
  //static ama '_' ile erişilemiyor factory methodu uygulanabilsin diye ekledim

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

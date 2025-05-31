import 'package:asset_tracker/core/constants/enums/auth/auth_error_state_enums.dart';
import 'package:asset_tracker/core/config/theme/extension/auth_error_extension.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/data/model/base/error/error_model.dart';
import 'package:flutter/material.dart';

//we wont use equatable in here because we have no logic to compare
@immutable
// ignore: must_be_immutable
final class AuthErrorModel extends BaseErrorModel {
  final AuthErrorState? errorState;
  String? errorCode;

  AuthErrorModel({super.message, required this.errorState}) {
    errorCode = errorState?.value ?? DefaultLocalStrings.emptyText;
  }

  factory AuthErrorModel.fromErrorCode(String errorCode) {
    //error code a göre authErrorState enum u buluyor.
    final AuthErrorState errorState = errorCode.searchErrorState(errorCode);

    //errorCode Enum Type ına göre içindeki değeri (Localize edilmiş hata mesajını alıyor)
    String message = errorState.fromErrorToModel();
    //gelen hatayı mesaja çevirip nesneyi tekrar türetiyoruz
    return AuthErrorModel(errorState: errorState, message: message);
  }
  //static ama '_' ile erişilemiyor factory methodu uygulanabilsin diye ekledim

}

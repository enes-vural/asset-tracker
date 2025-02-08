import 'package:asset_tracker/data/model/auth/error/auth_error_state.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../localization/generated/locale_keys.g.dart';

extension GetAuthErrorType on String {
  ///error code a göre authErrorState enum u buluyor.
  AuthErrorState searchErrorState(String errorCode) {
    return AuthErrorState.values.firstWhere((state) => state.value == errorCode,
        orElse: () => AuthErrorState.GENERAL_ERR);
  }
}

extension ConvertAuthErrorType on AuthErrorState {
  ///errorCode Enum Type ına göre içindeki değeri (Localize edilmiş hata mesajını alıyor)
  String fromErrorToModel() {
    //TODO:
    //BU EXTENSION DAHIL BU TYPE KALKACAK
    //HİYEARŞİK ENUM YAPISI KURULARAK
    //ENUMLER ÇİFT PARAMETRE ALACAK
    //OTOMATIK OLARAK GELEN DATANIN AÇIKLAMASI LOCALIZE ŞEKLİNDE EKLENECEK
    //EKSTRA BİR EXTENSION İLE BU DURUM KULLANILMAYACAK
    //TODO:
    switch (this) {
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
}

import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/data/model/auth/error/auth_error_state.dart';
import 'package:asset_tracker/data/model/base/error/error_model.dart';

//we wont use equatable in here because we have no logic to compare
final class AuthErrorModel extends BaseErrorModel {
  final String errorCode;
  AuthErrorModel({super.message, required this.errorCode});

  AuthErrorModel toErrorModel() {
    //burada gelen hata kodundan error mesajımızı oluşturuyoruz.
    String message = _fromErrorToModel(errorCode);
    //gelen hatayı mesaja çevirip nesneyi tekrar türetiyoruz
    return AuthErrorModel(errorCode: errorCode).copyWith(message: message);
  }

  String _fromErrorToModel(String error) {
    switch (error) {
      case (AuthErrorState.ACCOUNT_EXIST):
        return "There is already account like that";
      case (AuthErrorState.INVALID_CRED):
        return "Your email or password is wrong.";
      case (AuthErrorState.NOT_FOUND):
        return "The account not found";
      case (AuthErrorState.INVALID_EMAIL):
        return "Invalid email";
      case (AuthErrorState.REQUEST_QUOTA):
        return "You attend too many request, please try later";
      case (AuthErrorState.TIMEOUT):
        return "Over Timeout, try again";
      case (AuthErrorState.USER_DISABLED):
        return "This account is no longer available ";
      case (AuthErrorState.WRONG_PASSWORD):
        return "Invalid password";
      //firebase tarafından olmayan sistemsel hatalarda GENERAL_ERR kullanilacagi
      //icin default a düşmek istemiyoruz.
      case (AuthErrorState.GENERAL_ERR):
        return "Error has been occurred";
      default:
        return DefaultLocalStrings.emptyText;
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

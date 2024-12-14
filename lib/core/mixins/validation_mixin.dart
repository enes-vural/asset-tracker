import 'package:asset_tracker/core/config/constants/reg_exp_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

mixin ValidatorMixin {
  final _emailRegex = RegExpConstant.emailCheckRegExp;
  //E-mail de olması gereken karakterleri RegExp ile belirttik.
  /// @ işaretinden sonra karakter ve . bulunması vb.
  String? checkEmail(String? text) {
    return text != null && text.isNotEmpty //text null ve ya boş değilse
        ? _emailRegex.hasMatch(text) // ve _emailRegex i barındırıyorsaq
            ? null
            : LocaleKeys.auth_validation_weakEmail.tr()
        : LocaleKeys.auth_validation_noneEmail.tr();
  }

  String? checkPassword(String? text) {
    return text != null && text.isNotEmpty
        ? text.length >= 6
            ? null
            : LocaleKeys.auth_validation_weakPassword.tr()
        : LocaleKeys.auth_validation_nonePassword.tr();
  }
}

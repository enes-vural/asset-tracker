import 'package:asset_tracker/core/config/constants/global/general_constants.dart';
import 'package:asset_tracker/core/config/constants/reg_exp_constant.dart';
import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

mixin ValidatorMixin {
  final _emailRegex = RegExpConstant.emailCheckRegExp;
  final _numberRegex = RegExpConstant.onlyNumbersAndDot;
  final _passwordLength = GeneralConstants.maxPasswordLength;
  //E-mail de olması gereken karakterleri RegExp ile belirttik.
  /// @ işaretinden sonra karakter ve . bulunması vb.
  String? checkEmail(String? text) {
    return text != null && text.isNotEmpty //text null ve ya boş değilse
        ? _emailRegex.hasMatch(text) // ve _emailRegex i barındırıyorsaq
            ? null
            : LocaleKeys.auth_validation_weakEmail.tr()
        : LocaleKeys.auth_validation_noneEmail.tr();
  }

  ///Password null durumunu kontrol ediyor eğer değilse sonraki kontrolünde
  ///text uzunluğunu GeneralConstants sınıfından aldığımız maxPasswordLength ile kontrol ediyor
  ///her şey tamam ise null döndürüp validasyionu tamamlıyor.
  String? checkPassword(String? text) {
    return text != null && text.isNotEmpty
        ? text.length >= _passwordLength
            ? null
            : LocaleKeys.auth_validation_weakPassword.tr()
        : LocaleKeys.auth_validation_nonePassword.tr();
  }

  String? checkAmount(String? text, bool isPrice) {
    //isPrice true ise fiyat kontrolü yapılır
    //isPrice false ise miktar kontrolü yapılır

    if (text == null || text.isEmpty) {
      return LocaleKeys.trade_fillAllFields.tr();
    }
    try {
      if (double.tryParse(text) == null) {
        return isPrice
            ? LocaleKeys.trade_invalidPrice.tr()
            : LocaleKeys.trade_invalidAmount.tr();
      }
    } catch (e) {
      return isPrice
          ? LocaleKeys.trade_invalidPrice.tr()
          : LocaleKeys.trade_invalidAmount.tr();
    }

    if (!_numberRegex.hasMatch(text)) {
      return LocaleKeys.trade_invalidType.tr();
    }
    return null;
  }
}

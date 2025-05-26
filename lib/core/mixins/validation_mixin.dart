import 'package:asset_tracker/core/constants/global/general_constants.dart';
import 'package:asset_tracker/core/constants/reg_exp_constant.dart';
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


String? checkDateTime(String? text) {
    if (text == null || text.isEmpty) {
      return LocaleKeys.trade_fillAllFields.tr();
    }

    // dd/MM/yyyy formatını kontrol et
    final datePattern = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (datePattern.hasMatch(text)) {
      // Opsiyonel: Tarihin geçerli olup olmadığını da kontrol edebilirsiniz
      try {
        final parts = text.split('/');
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);

        // Geçerli tarih kontrolü
        final date = DateTime(year, month, day);
        if (date.day != day || date.month != month || date.year != year) {
          return LocaleKeys.trade_invalidDate
              .tr(); // Geçersiz tarih (örn: 31/02/2025)
        }

        return null; // Geçerli dd/MM/yyyy formatında ise null döndür
      } catch (e) {
        return LocaleKeys.trade_invalidDate.tr(); // Parse hatası
      }
    }

    // Diğer durumlar için validasyon yap
    try {
      final date = DateTime.parse(text);
      if (date.isBefore(DateTime.now())) {
        return LocaleKeys.trade_invalidDate.tr();
      }
    } catch (e) {
      return LocaleKeys.trade_invalidDate.tr();
    }

    return null;
  }


  //Default bir check validation yaz
  String? checkText(String? text) {
    return text != null && text.isNotEmpty ? null : "Bu alan boş bırakılamaz.";
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

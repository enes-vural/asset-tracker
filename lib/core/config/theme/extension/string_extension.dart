import 'package:asset_tracker/core/constants/string_constant.dart';

extension RemoveCurrencySign on String {
  String removeTurkishLiraSign() => replaceAll(
      DefaultLocalStrings.turkishLira, DefaultLocalStrings.emptyText);
}

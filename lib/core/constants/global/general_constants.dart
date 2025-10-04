import 'package:easy_localization/easy_localization.dart';

final class GeneralConstants {
  static const int maxPasswordLength = 6;
  static const int socketJsonInitialIndex = 19;
  static const int socketFirstDoubleIndexJson = 2;
  static const int delayBetweenReconnect = 3;

  static DateFormat dateFormat = DateFormat("dd MMMM");

  static String appGroupId = "group.parota";
  static String iosWidgetId = "parotawidget";
  static String androidWidgetId = "PaRotaWidgetReceiver";

}

import 'dart:async';
import 'package:asset_tracker/core/config/theme/extension/currency_widget_title_extension.dart';
import 'package:asset_tracker/core/routers/router.dart' show Routers;
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/entities/web/socket/currency_entity.dart';
import 'package:asset_tracker/domain/usecase/database/database_use_case.dart';
import 'package:asset_tracker/domain/usecase/messaging/messaging_use_case.dart';
import 'package:asset_tracker/domain/usecase/web/web_use_case.dart';
import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewModel extends ChangeNotifier {
  final GetSocketStreamUseCase getSocketStreamUseCase;

  HomeViewModel({required this.getSocketStreamUseCase});

  final TextEditingController searchBarController = TextEditingController();

  StreamController? dataStreamController;
  Stream? socketDataStream;

  double? newBalance;
  double? totalProfit;

  final StreamController<String> _searchBarStreamController =
      StreamController<String>.broadcast();

  initHomeView() {
    searchBarController.addListener(() {
      _searchBarStreamController.add(searchBarController.text);
    });
  }

  void listenToSocketData(WidgetRef ref) {
    // Riverpod yaklaşımı:
    final socketState = ref.watch(webSocketProvider);
    if (socketState.socketDataStream != null) {
      ref
          .read(appGlobalProvider.notifier)
          .updateSocketCurrency(socketState.socketDataStream);
    }

    // veya Singleton yaklaşımı:
    // if (SocketService().socketDataStream != null) {
    //   ref.read(appGlobalProvider.notifier).updateSocketCurrency(SocketService().socketDataStream);
    // }
  }

  Future<void> syncNotificationSettings(WidgetRef ref) async {
    final isPermitted =
        await getIt<NotificationUseCase>().isPermissionAuthorized();
    if (isPermitted) {
      debugPrint("PERMISSION: $isPermitted");
      String? token = await getIt<NotificationUseCase>().getUserToken();
      debugPrint("PERMISSION: $token");
      if (token != null) {
        ref.read(authGlobalProvider).updateFcmToken(token);
        await saveUserToken(ref, token);
        return;
      }
    }
    return;
  }

  Future<void> saveUserToken(WidgetRef ref, String fcmToken) async {
    String? userId = ref.read(authGlobalProvider).getCurrentUserId;
    if (userId != null) {
      await getIt<DatabaseUseCase>()
          .saveUserToken(UserUidEntity(userId: userId), fcmToken);
    }
    return;
  }

  // Future<void> getData(WidgetRef ref) async {
  //   //if stream is already open, we don't need to open it again
  //   if (dataStreamController?.stream != null) {
  //     return;
  //   }

  //   final data = await getSocketStreamUseCase.call(null);
  //   // debugPrint(data.toString());
  //   data.fold((failure) => debugPrint(failure.message), (success) {
  //     debugPrint("Connection STATE : ${success.state}");
  //   });

  //   dataStreamController = getSocketStreamUseCase.controller;
  //   socketDataStream = dataStreamController?.stream.asBroadcastStream();

  //   ref.read(appGlobalProvider.notifier).updateSocketCurrency(socketDataStream);
  //   notifyListeners();
  // }

  // Future<void> getErrorStream({required BuildContext parentContext}) async {
  //   final Stream<Either<SocketErrorEntity, SocketStateResponseModel>>? data =
  //       getSocketStreamUseCase.getErrorStream();
  //   data?.listen((event) {
  //     event.fold((failure) {
  //       //commented for UX
  //       //EasySnackBar.show(parentContext, failure.message);
  //     }, (success) {
  //       debugPrint("Connection STATE : ${success.state}");
  //       debugPrint("Connection STATE : ${success.message}");
  //     });
  //   });
  // }

  filterCurrencyData(List<CurrencyEntity>? data, String searchedCurrency) {
    //filter the list via controller's value
    if (searchedCurrency.isNotEmpty && searchedCurrency != "") {
      final filteredData = data?.where((CurrencyEntity element) {
        return element.code
                .toLowerCase()
                .contains(searchedCurrency.toLowerCase()) ||
            setCurrencyLabel(element.code)
                .toLowerCase()
                .contains(searchedCurrency.toLowerCase());
      }).toList();

      return filteredData;
    }
    return data;
  }

  void clearText() {
    searchBarController.clear();
  }

  void routeWalletPage(BuildContext context) {
    Routers.instance.pushNamed(context, Routers.dashboardPath);
  }

  void routeSignInPage(BuildContext context) {
    Routers.instance.pushNamed(context, Routers.loginPath);
  }

  Stream? get searchBarStreamController => _searchBarStreamController.stream;
  Stream get getEmptyStream => const Stream.empty(broadcast: true);
  // we will get stream after ensure connection is done !
}

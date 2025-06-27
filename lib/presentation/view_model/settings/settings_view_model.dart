import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/constants/enums/widgets/app_pages_enum.dart';
import 'package:asset_tracker/core/constants/string_constant.dart';
import 'package:asset_tracker/core/helpers/snackbar.dart';
import 'package:asset_tracker/core/routers/router.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_info_entity.dart';
import 'package:asset_tracker/domain/entities/database/enttiy/user_uid_entity.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:asset_tracker/domain/usecase/cache/cache_use_case.dart';
import 'package:asset_tracker/domain/usecase/database/database_use_case.dart';
import 'package:asset_tracker/provider/app_global_provider.dart';
import 'package:asset_tracker/provider/auth_global_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsViewModel extends ChangeNotifier {
  final AuthUseCase authUseCase;
  final AppGlobalProvider appGlobalProvider;
  final AuthGlobalProvider authGlobalProvider;
  final DatabaseUseCase databaseUseCase;
  final CacheUseCase cacheUseCase;

  SettingsViewModel(
    this.authUseCase,
    this.appGlobalProvider,
    this.authGlobalProvider,
    this.databaseUseCase,
    this.cacheUseCase,
  );

  final nameController = TextEditingController();
  final surnameController = TextEditingController();

  initControllerText() async {
    final userData = appGlobalProvider.getUserData;
    nameController.text =
        userData?.userInfoEntity?.firstName ?? DefaultLocalStrings.emptyText;
    surnameController.text =
        userData?.userInfoEntity?.lastName ?? DefaultLocalStrings.emptyText;
  }

  sendEmailVerification(BuildContext context) async {
    final data = await authUseCase.sendEmailVerification();
    data.fold(
      (failure) {
        debugPrint(failure.message);
      },
      (success) {
        EasySnackBar.show(
            context, "E-posta adresinize doğrulama linkini gönderdik.");
      },
    );
  }

  Future<void> changeUserInfo(BuildContext context) async {
    final userData = appGlobalProvider.getUserData;
    final String? firstName = userData?.userInfoEntity?.firstName;
    final String? lastName = userData?.userInfoEntity?.lastName;

    //name can not be null or empty
    if (nameController.text.isEmpty) {
      Routers.instance.pop(context);
      return;
    }

    if (nameController.text == firstName &&
        surnameController.text == lastName) {
      Routers.instance.pop(context);
      return;
    }
    if (userData?.userInfoEntity != null && userData != null) {
      final UserInfoEntity userInfo = userData.userInfoEntity!.copyWith(
          firstName: nameController.text, lastName: surnameController.text);
      appGlobalProvider.updateUserInfo(userInfo);

      final data = await databaseUseCase.changeUserInfo(userInfo);

      data.fold(
        (failure) {
          EasySnackBar.show(
              context, LocaleKeys.home_settings_processError.tr());
        },
        (success) {
          EasySnackBar.show(context, LocaleKeys.home_settings_infoUpdated.tr());
          Routers.instance.pop(context);
        },
      );
    }
  }

  Future<void> signOut(WidgetRef ref, BuildContext context) async {
    await authUseCase.signOut();
    await appGlobalProvider.clearData();
    //Firebase rules gereği, kullanıcı oturumu kapatıldığında offline işlemler silinmeli.
    await cacheUseCase.clearAllOfflineActions();
    //clear old routes before pushing new route
    //Routers.instance.replaceAll(context, const LoginRoute());
    //Routers.instance.pushAndRemoveUntil(context, const LoginRoute());
    notifyListeners();
  }

  //Buraya Offline first gelmeyecek.
  Future<void> deleteAccount(BuildContext context) async {
    try {
      // İki işlemi paralel olarak başlat
      final List<Future> futures = [];

      // Auth silme işlemi
      futures.add(authUseCase.deleteAccount());

      // Database silme işlemi (eğer user ID varsa)
      if (authGlobalProvider.getCurrentUserId != null) {
        futures.add(databaseUseCase.removeUserData(
            UserUidEntity(userId: authGlobalProvider.getCurrentUserId!)));
      }

      // Tüm işlemlerin tamamlanmasını bekle
      final results = await Future.wait(futures, eagerError: false);

      // Hata kontrolü
      bool hasError = false;
      String? errorMessage;

      // Auth result kontrolü
      final authResult = results[0];
      authResult.fold(
        (failure) {
          hasError = true;
          errorMessage = failure.message;
        },
        (success) => null,
      );

      // Database result kontrolü (eğer varsa)
      if (results.length > 1) {
        final dbResult = results[1];
        dbResult.fold(
          (failure) {
            hasError = true;
            errorMessage ??= failure.message;
          },
          (success) => null,
        );
      }

      if (context.mounted) {
        if (hasError) {
          EasySnackBar.show(context, errorMessage!);
        } else {
          await appGlobalProvider.clearData();
          if (context.mounted) {
            Routers.instance.pop(context);
            EasySnackBar.show(
                context, LocaleKeys.home_settings_deleteSuccesfull.tr());
            appGlobalProvider
                .changeMenuNavigationIndex(AppPagesEnum.HOME.pageIndex);
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        EasySnackBar.show(context, LocaleKeys.home_settings_deleteError.tr());
      }
    }
  }

  bool get isAuthorized => authGlobalProvider.isUserAuthorized;
}

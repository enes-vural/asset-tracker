import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';
import 'package:asset_tracker/domain/usecase/auth/auth_use_case.dart';
import 'package:asset_tracker/domain/usecase/cache/cache_use_case.dart';
import 'package:asset_tracker/domain/usecase/database/database_use_case.dart';

import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SyncManager {

  Future<void> syncOfflineActions() async {
    List<OfflineActionsModel> actions =
        getIt<CacheUseCase>().getOfflineActions();
    if (actions.isEmpty) {
      debugPrint("No offline actions to sync");
      return;
    }
    for (OfflineActionsModel action in actions) {
      try {
        switch (action.type) {
          case OfflineActionType.LOGIN:

            final result = await getIt<AuthUseCase>().call(action.params);
            if (result.isRight()) {
              await getIt<CacheUseCase>().removeOfflineAction(action.id);
            } else {
              debugPrint("Login failed, keeping offline action");
            }

          case OfflineActionType.BUY_ASSET:
            //TODO:
            //Left error kontrolüne göre silme işlemi eklenecek.
            final result = await getIt<DatabaseUseCase>().call(action.params);
            if (result.isRight()) {
              await getIt<CacheUseCase>().removeOfflineAction(action.id);
              debugPrint("Asset bought successfully");
            } else {
              debugPrint("Buy asset failed, keeping offline action");
            }

            break;
          default:
            debugPrint("Unknown action type: ${action.type}");
            break;
        }
      } catch (e) {
        debugPrint(e.toString());
        debugPrint("Error syncing offline action: $e");
        // Handle error (e.g., log it, show a notification, etc.)
      }
    }
  }

  Future<void> syncOfflineActionHeadless() async {
    //headless container
    final hContainer = ProviderContainer();
    List<OfflineActionsModel> actions =
        getIt<CacheUseCase>().getOfflineActions();
    if (actions.isEmpty) {
      debugPrint("No offline actions to sync");
      return;
    }
    for (OfflineActionsModel action in actions) {
      try {
        switch (action.type) {
          case OfflineActionType.LOGIN:

            final result = await getIt<AuthUseCase>().call(action.params);
            if (result.isRight()) {
              await getIt<CacheUseCase>().removeOfflineAction(action.id);
            } else {
              debugPrint("Login failed, keeping offline action");
            }

          case OfflineActionType.BUY_ASSET:
            //TODO:
            //Left error kontrolüne göre silme işlemi eklenecek.
            final result = await getIt<DatabaseUseCase>().call(action.params);
            if (result.isRight()) {
              await getIt<CacheUseCase>().removeOfflineAction(action.id);
              debugPrint("Asset bought successfully");
            } else {
              debugPrint("Buy asset failed, keeping offline action");
            }

            break;
          default:
            debugPrint("Unknown action type: ${action.type}");
            break;
        }
      } catch (e) {
        debugPrint(e.toString());
        debugPrint("Error syncing offline action: $e");
        // Handle error (e.g., log it, show a notification, etc.)
      }
    }
    hContainer.dispose();
    debugPrint("Headless container disposed");
  }

  // Add your methods and properties here
}

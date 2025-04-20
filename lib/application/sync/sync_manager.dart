import 'package:asset_tracker/core/constants/enums/cache/offline_action_enums.dart';
import 'package:asset_tracker/data/model/cache/offline_actions_model.dart';

import 'package:asset_tracker/injection.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SyncManager {
  final T Function<T>(ProviderListenable<T>) read;
  SyncManager(this.read);

  Future<void> syncOfflineActions() async {
    final cacheUseCase = read(cacheUseCaseProvider);
    List<OfflineActionsModel> actions = cacheUseCase.getOfflineActions();
    if (actions.isEmpty) {
      debugPrint("No offline actions to sync");
      return;
    }
    for (OfflineActionsModel action in actions) {
      try {
        switch (action.type) {
          case OfflineActionType.LOGIN:
            final result =
                await read(signInUseCaseProvider).call(action.params);
            if (result.isRight()) {
              await cacheUseCase.removeOfflineAction(action.id);
            } else {
              debugPrint("Login failed, keeping offline action");
            }

          case OfflineActionType.BUY_ASSET:
            //TODO:
            //Left error kontrolüne göre silme işlemi eklenecek.
            final result =
                await read(buyCurrencyUseCaseProvider).call(action.params);
            if (result.isRight()) {
              await cacheUseCase.removeOfflineAction(action.id);
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
    final cacheUseCase = hContainer.read(cacheUseCaseProvider);
    List<OfflineActionsModel> actions = cacheUseCase.getOfflineActions();
    if (actions.isEmpty) {
      debugPrint("No offline actions to sync");
      return;
    }
    for (OfflineActionsModel action in actions) {
      try {
        switch (action.type) {
          case OfflineActionType.LOGIN:
            final signInUseCase = hContainer.read(signInUseCaseProvider);
            final result = await signInUseCase.call(action.params);
            if (result.isRight()) {
              await cacheUseCase.removeOfflineAction(action.id);
            } else {
              debugPrint("Login failed, keeping offline action");
            }

          case OfflineActionType.BUY_ASSET:
            //TODO:
            //Left error kontrolüne göre silme işlemi eklenecek.
            final buyCurrencyUseCase =
                hContainer.read(buyCurrencyUseCaseProvider);
            final result = await buyCurrencyUseCase.call(action.params);
            if (result.isRight()) {
              await cacheUseCase.removeOfflineAction(action.id);
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

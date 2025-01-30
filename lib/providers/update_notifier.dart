import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:in_app_update/in_app_update.dart';

// Provider to manage and check for app updates.
final updateNotifierProvider =
    NotifierProvider<UpdateNotifier, AppUpdateInfo?>(UpdateNotifier.new);

class UpdateNotifier extends Notifier<AppUpdateInfo?> {
  @override
  AppUpdateInfo? build() => null;

  /// Check for available updates
  Future<void> checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      state = updateInfo;

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          await performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          await startFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint("Error checking for update: $e");
    }
  }

  /// Perform an immediate update
  Future<AppUpdateResult> performImmediateUpdate() async {
    try {
      return await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      debugPrint("Immediate update failed: $e");
      return AppUpdateResult.userDeniedUpdate; // Fallback on failure
    }
  }

  /// Perform a flexible update
  Future<AppUpdateResult> startFlexibleUpdate() async {
    try {
      // Start the flexible update (download the update in the background)
      await InAppUpdate.startFlexibleUpdate();

      // Wait for the update to complete
      await InAppUpdate.completeFlexibleUpdate();

      // Restart the app automatically once the update is applied
      restartApp();

      // Return success to the caller
      return AppUpdateResult.success;
    } catch (e) {
      debugPrint("Flexible update failed: $e");
      return AppUpdateResult.userDeniedUpdate; // Fallback on failure
    }
  }

  // Perform a restart of the app automatically once the update is applied
  void restartApp() {
    // This will restart the app by navigating to the home screen and clearing the stack.
    SystemNavigator.pop();
    // The app will automatically restart upon launching it again.
  }
}

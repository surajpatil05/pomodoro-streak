import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';

class AppUpdateService {
  /// Check for available updates
  Future<AppUpdateInfo?> checkForUpdate() async {
    try {
      return await InAppUpdate.checkForUpdate();
    } catch (e) {
      debugPrint("Error checking for update: $e");
      return null;
    }
  }

  /// Perform an immediate update
  Future<AppUpdateResult> performImmediateUpdate() async {
    try {
      return await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      debugPrint("Immediate update failed: $e");
      return AppUpdateResult.userDeniedUpdate;
    }
  }

  /// Perform a flexible update
  Future<AppUpdateResult> startFlexibleUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
      restartApp();
      return AppUpdateResult.success;
    } catch (e) {
      debugPrint("Flexible update failed: $e");
      return AppUpdateResult.userDeniedUpdate;
    }
  }

  /// Restart the app
  void restartApp() {
    SystemNavigator.pop();
  }
}

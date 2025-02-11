import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import '../services/app_update_service.dart';

// Provider for App Update
final appUpdateProvider = NotifierProvider<AppUpdateViewModel, AppUpdateInfo?>(
    AppUpdateViewModel.new);

class AppUpdateViewModel extends Notifier<AppUpdateInfo?> {
  final AppUpdateService _updateService = AppUpdateService();

  @override
  AppUpdateInfo? build() => null;

  /// Check for available updates
  Future<void> checkForUpdate(void Function(AppUpdateInfo?) showDialog) async {
    final updateInfo = await _updateService.checkForUpdate();
    state = updateInfo;

    if (updateInfo != null &&
        updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      showDialog(updateInfo);
    }
  }

  Future<void> performUpdate(
      BuildContext context, AppUpdateInfo updateInfo) async {
    Navigator.of(context).pop(); // Dismiss the dialog

    if (updateInfo.immediateUpdateAllowed) {
      await _updateService.performImmediateUpdate();
    } else if (updateInfo.flexibleUpdateAllowed) {
      await _updateService.startFlexibleUpdate();
    }
  }
}

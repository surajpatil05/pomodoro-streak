import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import '../services/app_update_service.dart';

// Provider for App Update
final appUpdateProvider =
    NotifierProvider<AppUpdateNotifier, AppUpdateInfo?>(AppUpdateNotifier.new);

class AppUpdateNotifier extends Notifier<AppUpdateInfo?> {
  final AppUpdateService _updateService = AppUpdateService();

  @override
  AppUpdateInfo? build() => null;

  /// Check for available updates
  Future<void> checkForUpdate() async {
    final updateInfo = await _updateService.checkForUpdate();
    if (updateInfo != null) {
      state = updateInfo;

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          await _updateService.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          await _updateService.startFlexibleUpdate();
        }
      }
    }
  }
}

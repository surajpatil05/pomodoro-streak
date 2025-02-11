import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleFocusBreakModeViewModel extends Notifier<bool> {
  @override
  bool build() {
    // Default mode is Focus Mode (true)
    return true;
  }

  /// Set mode explicitly to Focus Mode
  void setFocusMode() {
    state = true;
  }

  /// Set mode explicitly to Break Mode
  void setBreakMode() {
    state = false;
  }
}

// used Switch between Focus and Break Mode
final toggleFocusBreakModeProvider =
    NotifierProvider<ToggleFocusBreakModeViewModel, bool>(() {
  return ToggleFocusBreakModeViewModel();
});

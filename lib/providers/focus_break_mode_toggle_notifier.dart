import 'package:flutter_riverpod/flutter_riverpod.dart';

class FocusBreakModeNotifier extends Notifier<bool> {
  @override
  bool build() {
    // Default mode is Focus Mode (true)
    return true;
  }

  /// Toggles the mode between Focus and Break
  void toggleMode() {
    state = !state;
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

final focusBreakModeProvider =
    NotifierProvider<FocusBreakModeNotifier, bool>(() {
  return FocusBreakModeNotifier();
});

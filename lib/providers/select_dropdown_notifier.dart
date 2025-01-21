// selected_timeline_option_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_streak/providers/focus_timer_notifier.dart';

class SelectDropDownNotifier extends Notifier<String> {
  SelectDropDownNotifier({required String initialOption})
      : _highlightedOption = initialOption,
        _selectOption = initialOption;

  String _highlightedOption; // default highlighted option
  String _selectOption; // default selected option

  @override
  String build() {
    return _highlightedOption; // initially return the highlighted option
  }

  String get selectedOption => _selectOption;
  String get highlightedOption => _highlightedOption;

  void setHighlightedOption(String newOption) {
    _highlightedOption = newOption;
    state = _highlightedOption; // Update state for UI
  }

  void confirmSelection() {
    _selectOption = _highlightedOption; // confirm the highlighted option
    // Optionally, update the state to reflect the selection
    state = selectedOption;
  }
}

// Dropdown option Provider for Focus and Break Mode
final selectDropDownProvider = NotifierProvider<SelectDropDownNotifier, String>(
  () => SelectDropDownNotifier(
    initialOption: 'Today', // Default value for initialization
  ),
);

// Sync function to update the dropdown state with focusTimerProvider
void syncWithFocusTimer(WidgetRef ref) {
  final focusTimeline = ref.read(focusTimerProvider).selectedTimeline;
  ref.read(selectDropDownProvider.notifier).setHighlightedOption(focusTimeline);
}

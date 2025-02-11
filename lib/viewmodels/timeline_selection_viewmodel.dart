import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomodoro_streak/viewmodels/break_timer_viewmodel.dart';

import 'package:pomodoro_streak/viewmodels/focus_timer_viewmodel.dart';

class TimelineSelectionViewModel extends Notifier<String> {
  TimelineSelectionViewModel({required String initialOption})
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
    debugPrint('Setting highlighted option: $selectedOption');
    state = selectedOption;
  }
}

// Dropdown option Provider for Focus and Break Mode
final timelineSelectionProvider =
    NotifierProvider<TimelineSelectionViewModel, String>(
  () => TimelineSelectionViewModel(
    initialOption: 'Today', // Default value for initialization
  ),
);

// Sync function to update the dropdown state with focusTimerProvider
void syncWithFocusTimer(WidgetRef ref) {
  final focusTimeline = ref.read(focusTimerProvider).selectedTimeline;
  ref
      .read(timelineSelectionProvider.notifier)
      .setHighlightedOption(focusTimeline);
}

// Sync function to update the dropdown state with breakTimerProvider
void syncWithBreakTimer(WidgetRef ref) {
  final breakTimeline = ref.read(breakTimerProvider).selectedTimeline;
  ref
      .read(timelineSelectionProvider.notifier)
      .setHighlightedOption(breakTimeline);
}

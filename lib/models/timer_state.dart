import 'package:pomodoro_streak/models/timer_model.dart';

class TimerState {
  final bool isRunning;
  final bool isPaused;
  final bool isStarting;
  final bool isFocusMode;
  final String selectedTimeline;
  final int selectedBreakTimeOption;
  final int selectedFocusTimeOption;
  final TimerModel timerModel; // Storing tracked data here

  TimerState({
    required this.isRunning,
    required this.isPaused,
    required this.isStarting,
    this.isFocusMode = true,
    required this.selectedTimeline,
    this.selectedBreakTimeOption = 0,
    this.selectedFocusTimeOption = 0,
    required this.timerModel,
  });

  // Method to copy state with changes
  TimerState copyWith({
    bool? isRunning,
    bool? isPaused,
    bool? isStarting,
    bool? isFocusMode,
    String? selectedTimeline,
    int? selectedBreakTimeOption,
    int? selectedFocusTimeOption,
    TimerModel? timerModel, // Updating full model when needed
  }) {
    return TimerState(
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      isStarting: isStarting ?? this.isStarting,
      isFocusMode: isFocusMode ?? this.isFocusMode,
      selectedTimeline: selectedTimeline ?? this.selectedTimeline,
      selectedBreakTimeOption:
          selectedBreakTimeOption ?? this.selectedBreakTimeOption,
      selectedFocusTimeOption:
          selectedFocusTimeOption ?? this.selectedFocusTimeOption,
      timerModel: timerModel ?? this.timerModel,
    );
  }
}

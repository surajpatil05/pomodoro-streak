// TimerState class to hold the state
import 'package:flutter/material.dart';

class TimerState {
  final int focusTime; // Focus mode time
  final int breakTime; // Break mode time
  final bool isRunning;
  final bool isPaused;
  final bool isFocusMode;
  final int defaultFocusTimeOption; // Selected Focus time option
  final int defaultBreakTimeOption; // Selected Break time option
  final int cyclesToday; // cycles complete today
  final int cyclesThisWeek; // cycles compleed this week
  final int cyclesThisMonth; // cycles completed this month
  final int totalCycles; // cycles completed total this month
  final int timeSpentToday; // total time spent today
  final int timeSpentThisWeek; // total time spent this week
  final int timeSpentThisMonth; // total time spent this month
  final int totalTimeSpent;
  final String selectedTimeline;

  TimerState({
    required this.focusTime,
    required this.breakTime,
    required this.isRunning,
    required this.isFocusMode,
    required this.defaultFocusTimeOption,
    required this.defaultBreakTimeOption,
    this.isPaused = false, // default to false
    required this.cyclesToday,
    required this.cyclesThisWeek,
    required this.cyclesThisMonth,
    required this.totalCycles,
    required this.timeSpentToday,
    required this.timeSpentThisWeek,
    required this.timeSpentThisMonth,
    required this.totalTimeSpent,
    required this.selectedTimeline,
  });

  TimerState copyWith({
    int? focusTime,
    int? breakTime,
    bool? isRunning,
    bool? isPaused,
    bool? isFocusMode,
    int? selectedFocusTimeOption,
    int? selectedBreakTimeOption,
    int? cyclesToday,
    int? cyclesThisWeek,
    int? cyclesThisMonth,
    int? totalCycles,
    int? timeSpentToday,
    int? timeSpentThisWeek,
    int? timeSpentThisMonth,
    int? totalTimeSpent,
    String? selectedTimeline,
  }) {
    return TimerState(
      focusTime: focusTime ?? this.focusTime,
      breakTime: breakTime ?? this.breakTime,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      isFocusMode: isFocusMode ?? this.isFocusMode,
      defaultFocusTimeOption: selectedFocusTimeOption ?? defaultFocusTimeOption,
      defaultBreakTimeOption: selectedBreakTimeOption ?? defaultBreakTimeOption,
      cyclesToday: cyclesToday ?? this.cyclesToday,
      cyclesThisWeek: cyclesThisWeek ?? this.cyclesThisWeek,
      cyclesThisMonth: cyclesThisMonth ?? this.cyclesThisMonth,
      totalCycles: totalCycles ?? this.totalCycles,
      timeSpentToday: timeSpentToday ?? this.timeSpentToday,
      timeSpentThisWeek: timeSpentThisWeek ?? this.timeSpentThisWeek,
      timeSpentThisMonth: timeSpentThisMonth ?? this.timeSpentThisMonth,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      selectedTimeline: selectedTimeline ?? this.selectedTimeline,
    );
  }

  // Helper to get cycle count based on selected timeline
  int getCyclesCount() {
    debugPrint('Selected Timeline: $selectedTimeline');
    debugPrint(
        'Cycles Today: $cyclesToday, This Week: $cyclesThisWeek, This Month: $cyclesThisMonth, Total: $totalCycles');
    switch (selectedTimeline) {
      case 'Today':
        return cyclesToday;

      case 'This Week':
        return cyclesThisWeek;

      case 'This Month':
        return cyclesThisMonth;

      case 'Total Time':
        return totalCycles;
      default:
        return 0;
    }
  }

  // Helper to format time spent based on selected timeline
  String formatTimeSpent() {
    int timeSpent;
    switch (selectedTimeline) {
      case 'Today':
        timeSpent = timeSpentToday;
        break;
      case 'This Week':
        timeSpent = timeSpentThisWeek;
        break;
      case 'This Month':
        timeSpent = timeSpentThisMonth;
        break;
      case 'Total Time':
        timeSpent = totalTimeSpent;
        break;
      default:
        timeSpent = 0;
    }

    // timeSpent is formatted to HH:MM
    final hours = (timeSpent ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((timeSpent % 3600) ~/ 60).toString().padLeft(2, '0');
    return '$hours : $minutes';
  }
}

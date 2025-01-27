import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_streak/data/database_helper.dart';

import 'package:pomodoro_streak/model/timer_state.dart';
import 'package:pomodoro_streak/services/notification_service.dart';

// TimerNotifier class to manage the timer logic
class FocusTimerNotifier extends Notifier<TimerState> {
  Timer? _timer;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  TimerState build() {
    return TimerState(
      focusTime: 25 * 60,
      breakTime: 15 * 60,
      isRunning: false,
      isFocusMode: true,
      defaultFocusTimeOption: 25,
      defaultBreakTimeOption: 15,
      cyclesToday: 0,
      cyclesThisWeek: 0,
      cyclesThisMonth: 0,
      totalCycles: 0,
      timeSpentToday: 0,
      timeSpentThisWeek: 0,
      timeSpentThisMonth: 0,
      totalTimeSpent: 0,
      selectedTimeline: 'Today',
    );
  }

  // starts the Focus timer and deliver notification after the timer ends
  void startFocusTimer() {
    if (state.isRunning) return;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.focusTime > 0) {
        // Focus Mode Logic
        state = state.copyWith(
          focusTime: state.focusTime - 1, // Decrement focus time
          isRunning: true,
        );
      } else {
        timer.cancel();
        completeFocusPomodoroSession(); // Update cycle and time spent
        NotificationService().showNotification(
            title: 'PomodoroStreak', body: 'Pomodoro session Finished');
        resetFocusTimer(); // Reset the timer when it ends
      }
    });
    state = state.copyWith(isRunning: true);
  }

  // pauses the timer
  void pauseFocusTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false, isPaused: true);
  }

  // resumes the timer after pausing it
  void resumeFocusTimer() {
    if (!state.isPaused) return;
    startFocusTimer(); // Resume the timer
    state = state.copyWith(isPaused: false);
  }

  // Reset the timer
  void resetFocusTimer() {
    _timer?.cancel();
    state = state.copyWith(
      isRunning: false,
      isPaused: false,
      focusTime: state.defaultFocusTimeOption * 60,
    );
  }

  // Toggle between Focus and Break Modes
  void toggleFocusMode() {
    // Prevent switching modes if the timer is running or paused
    if (state.isRunning || state.isPaused) {
      return;
    }
    // Cancel the current timer
    _timer?.cancel();

    // Switch to focus mode
    state = state.copyWith(
      isFocusMode: true,
      isRunning: false,
      focusTime: state.defaultFocusTimeOption * 60,
    );
  }

  // Updates the default (Focus Mode Timer) to selected timer option [05, 15, 25, 30] Minutes
  void updateFocusTimeOption(int timeInMinutes) {
    state = state.copyWith(
      selectedFocusTimeOption: timeInMinutes,
      focusTime: timeInMinutes * 60, // Update focus time in seconds
      isRunning: false, // Reset the timer when a new time is selected
    );
  }

  // Update session and store data
  void completeFocusPomodoroSession() {
    // Add time to the appropriate category (today, week, month, total)
    final duration = state.defaultFocusTimeOption * 60; // duration in seconds

    int cyclesToday = state.cyclesToday + 1;
    int timeSpentToday = state.timeSpentToday + duration;

    // Save to database and update state
    _databaseHelper.insertFocusCycleCountAndTimeSpent(
      cyclesToday,
      timeSpentToday,
      DateTime.now(),
    );

    // Update state
    state = state.copyWith(
      cyclesToday: cyclesToday,
      timeSpentToday: timeSpentToday,
    );
  }

  // Fetch data (Cycle Count and Time Spent) for the selected timeline and update state
  Future<void> fetchFocusModeData(String timeline) async {
    final result =
        await _databaseHelper.fetchFocusCycleCountAndTimeSpentByRange(timeline);

    int cycleCount = 0;
    int timeSpent = 0;

    for (var row in result) {
      cycleCount += (row['cycle_count'] ?? 0) as int;
      timeSpent += (row['time_spent'] ?? 0) as int;
    }

    // Update only the relevant fields based on the timeline
    switch (timeline) {
      case 'Today':
        state = state.copyWith(
          cyclesToday: cycleCount,
          timeSpentToday: timeSpent,
        );
        break;
      case 'This Week':
        state = state.copyWith(
          cyclesThisWeek: cycleCount,
          timeSpentThisWeek: timeSpent,
        );
        break;
      case 'This Month':
        state = state.copyWith(
          cyclesThisMonth: cycleCount,
          timeSpentThisMonth: timeSpent,
        );
        break;
      case 'Total Time':
        state = state.copyWith(
          totalCycles: cycleCount,
          totalTimeSpent: timeSpent,
        );
        break;
    }
  }

  // Update the selected timeline in the state
  void updateSelectedTimeline(String timeline) {
    state = state.copyWith(selectedTimeline: timeline);

    fetchFocusModeData(
        timeline); // Fetch and update data for the new selected timeline from the bottomsheet
  }
}

// Provider for FocusTimerNotifier
final focusTimerProvider =
    NotifierProvider<FocusTimerNotifier, TimerState>(FocusTimerNotifier.new);

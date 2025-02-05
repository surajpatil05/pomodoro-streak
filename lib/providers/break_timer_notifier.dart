import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomodoro_streak/services/notification_service.dart';

import 'package:pomodoro_streak/data/database_helper.dart';

import 'package:pomodoro_streak/model/timer_state.dart';

import 'package:pomodoro_streak/providers/focus_break_mode_toggle_notifier.dart';

class BreakTimerNotifier extends Notifier<TimerState> {
  Timer? _timer;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Timer? _debounceTimer; // Timer for debouncing

  @override
  TimerState build() {
    return TimerState(
      focusTime: 25 * 60,
      breakTime: 15 * 60,
      isRunning: false,
      isStarting: false,
      isPaused: false,
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

  void _resetDebounce() {
    // If debounce timer exists, cancel it
    _debounceTimer?.cancel();
  }

  // starts the break timer and deliver notification after the timer ends
  void startBreakTimer() async {
    if (state.isRunning || state.isStarting) return;

    // If the timer is paused, simply resume it.
    if (state.isPaused) {
      state = state.copyWith(isPaused: false, isRunning: true);
    } else {
      // Immediately update the state so that isRunning becomes true.
      // This causes the UI to hide the START button and show PAUSE/RESUME.
      state =
          state.copyWith(isStarting: true, isRunning: true, isPaused: false);

      // // Immediately decrement time to avoid 1s delay

      // Once the initialization completes, clear the isStarting flag.
      state = state.copyWith(isStarting: false);
    }

    // Ensuring that only one timer is created to prevent conflicts
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (state.breakTime > 0) {
          // Decrement focus time
          state = state.copyWith(breakTime: state.breakTime - 1);
        } else {
          // Timer finished
          timer.cancel();
          completeBreakPomodoroSession();
          NotificationService().showNotification(
            title: 'PomodoroStreak',
            body: 'Break over! Time to focus again. 🔥',
          );

          ref
              .read(focusBreakModeProvider.notifier)
              .setFocusMode(); // Switch to Focus Mode after Break Timer ends

          // Reset the Break Timer after switching modes
          resetBreakTimer(); // Reset timer when session ends
        }
      });
    }
  }

  // pauses the timer
  void pauseBreakTimer() async {
    // Debounce logic to prevent rapid pausing/resuming before timer starts
    _resetDebounce();

    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      // If the timer is still starting, ignore the pause request.
      if (state.isRunning) {
        // Cancel the Active timer
        _timer?.cancel();

        // Otherwise, update the state to pause the timer.
        state = state.copyWith(isPaused: true, isRunning: false);
      }
    });
  }

  // Resumes the Break timer from the paused state
  void resumeBreakTimer() {
    // Debounce logic to prevent rapid pausing/resuming before timer starts
    _resetDebounce();

    // Prevent resuming if the timer is in the starting stage or if the timer is null
    if (state.isStarting || _timer == null) {
      // Debounce logic to prevent rapid pausing/resuming before timer starts
      _resetDebounce();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      // Prevent resuming if it's still in the starting phase
      if (state.isPaused) {
        startBreakTimer(); // Resume the timer
      }
    });
  }

  // reset the break
  void resetBreakTimer() {
    _timer?.cancel();
    state = state.copyWith(
      isRunning: false,
      isPaused: false,
      breakTime: state.defaultBreakTimeOption * 60,
    );
  }

  // Updates the break time option with the current break time from [01, 05, 15, 30] min
  void updateBreakTimeOption(int timeInMinutes) {
    state = state.copyWith(
      selectedBreakTimeOption: timeInMinutes,
      breakTime: timeInMinutes * 60, // // Update break time in seconds
      isRunning: false, // reset the timer when a new time is selected
    );
  }

  // Update session and store data
  void completeBreakPomodoroSession() {
    // Add time to the appropriate category (today, week, month, total)
    final duration = state.defaultBreakTimeOption * 60; // duration in seconds

    int cyclesToday = state.cyclesToday + 1;
    int timeSpentToday = state.timeSpentToday + duration;

    _databaseHelper.insertBreakCycleCountAndTimeSpent(
      cyclesToday,
      timeSpentToday,
      DateTime.now(),
    );

    state = state.copyWith(
      cyclesToday: cyclesToday,
      timeSpentToday: timeSpentToday,
    );
  }

// Fetch data (Cycle Count and Time Spent) for the selected timeline and update state
  Future<void> fetchBreakModeData(String timeline) async {
    final result =
        await _databaseHelper.fetchBreakCycleCountAndTimeSpentByRange(timeline);
    debugPrint('Fetched break data for $timeline: $result');

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
  Future<void> updateSelectedTimeline(String timeline) async {
    state = state.copyWith(selectedTimeline: timeline);

    await fetchBreakModeData(
        timeline); // Fetch and update data for the new selected from bottomsheet timeline
  }
}

// Provider for BreakTimerNotifier
final breakTimerProvider =
    NotifierProvider<BreakTimerNotifier, TimerState>(BreakTimerNotifier.new);

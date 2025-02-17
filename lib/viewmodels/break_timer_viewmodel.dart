import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomodoro_streak/data/repositories/timer_repository.dart';

import 'package:pomodoro_streak/models/timer_model.dart';

import 'package:pomodoro_streak/services/notification_service.dart';

import 'package:pomodoro_streak/models/timer_state.dart';

import 'package:pomodoro_streak/viewmodels/toggle_focusbreak_mode_viewmodel.dart';

class BreakTimerViewModel extends Notifier<TimerState> {
  Timer? _timer;
  final TimerRepository _databaseHelper = TimerRepository.instance;

  Timer? _debounceTimer; // Timer for debouncing

  @override
  TimerState build() {
    return TimerState(
      isRunning: false,
      isPaused: false,
      isStarting: false,
      selectedBreakTimeOption: 5,
      selectedTimeline: 'Today',
      timerModel: TimerModel(
        // Initialize TimerModel inside TimerState
        focusTime: 25 * 60, // 25 minutes
        breakTime: 5 * 60, // 5 minutes
        cyclesToday: 0,
        cyclesThisWeek: 0,
        cyclesThisMonth: 0,
        totalCycles: 0,
        timeSpentToday: 0,
        timeSpentThisWeek: 0,
        timeSpentThisMonth: 0,
        totalTimeSpent: 0,
        timestamp: DateTime.now(),
      ),
    );
  }

  // Reset the break time option to 5 minutes
  // every time when user switches between Focus and Break Mode
  void resetBreakTimeOption() {
    state = state.copyWith(
      selectedBreakTimeOption: 5,
      timerModel: state.timerModel.copyWith(breakTime: 5 * 60),
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
        if (state.timerModel.breakTime > 0) {
          // Decrement focus time
          state = state.copyWith(
              timerModel: state.timerModel
                  .copyWith(breakTime: state.timerModel.breakTime - 1));

          // Update the notification every second while the timer is running
          NotificationService().showOngoingTimerNotification(
              title: "Break Timer:",
              payload: 'break',
              secondsRemaining: state.timerModel.breakTime);
        } else {
          // Timer finished
          timer.cancel();

          // Cancel the notification when the timer finishes.
          NotificationService().cancelNotification();

          // insert timespent and cyclecount into database
          completeBreakPomodoroSession();

          // Show a notification when the Break session is completed
          NotificationService().showNotification(
            title: 'PomodoroStreak',
            body: 'Break over! Time to focus again. 🔥',
          );

          // Switch to Focus Mode after Break Timer ends
          ref
              .read(toggleFocusBreakModeProvider.notifier)
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

        // Cancel notification when timer is reset.
        NotificationService().cancelNotification();
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

    // Cancel notification when timer is reset
    NotificationService().cancelNotification();

    state = state.copyWith(
      isRunning: false,
      isPaused: false,
      timerModel: state.timerModel
          .copyWith(breakTime: state.selectedBreakTimeOption * 60),
    );
  }

  // Updates the break time option with the current break time from [01, 05, 15, 30] min
  void updateBreakTimeOption(int timeInMinutes) {
    state = state.copyWith(
      selectedBreakTimeOption: timeInMinutes,
      timerModel: state.timerModel.copyWith(breakTime: timeInMinutes * 60),
      isRunning: false, // reset the timer when a new time is selected
    );
  }

  // Update session and store data
  void completeBreakPomodoroSession() {
    // Add time to the appropriate category (today, week, month, total)
    final duration = state.selectedBreakTimeOption * 60; // duration in seconds

    int cyclesToday = 1;
    int timeSpentToday = duration;

    _databaseHelper.insertBreakCycleCountAndTimeSpent(
      cyclesToday,
      timeSpentToday,
      DateTime.now(),
    );

    // Fetch and update data for the current selected timeline
    fetchBreakModeData(state.selectedTimeline);
  }

  // Fetch data (Cycle Count and Time Spent) for the selected timeline and update state
  Future<void> fetchBreakModeData(String timeline) async {
    final result =
        await _databaseHelper.fetchBreakCycleCountAndTimeSpentByRange(timeline);
    debugPrint('Fetched break Mode data for $timeline: $result');

    int cycleCount = 0;
    int timeSpent = 0;

    for (var row in result) {
      cycleCount += (row['cycle_count'] ?? 0) as int;
      timeSpent += (row['time_spent'] ?? 0) as int;
    }

    // Update only the relevant fields based on the timeline
    state = state.copyWith(
      timerModel: state.timerModel.copyWith(
        cyclesToday:
            timeline == 'Today' ? cycleCount : state.timerModel.cyclesToday,
        timeSpentToday:
            timeline == 'Today' ? timeSpent : state.timerModel.timeSpentToday,
        cyclesThisWeek: timeline == 'This Week'
            ? cycleCount
            : state.timerModel.cyclesThisWeek,
        timeSpentThisWeek: timeline == 'This Week'
            ? timeSpent
            : state.timerModel.timeSpentThisWeek,
        cyclesThisMonth: timeline == 'This Month'
            ? cycleCount
            : state.timerModel.cyclesThisMonth,
        timeSpentThisMonth: timeline == 'This Month'
            ? timeSpent
            : state.timerModel.timeSpentThisMonth,
        totalCycles: timeline == 'Total Time'
            ? cycleCount
            : state.timerModel.totalCycles,
        totalTimeSpent: timeline == 'Total Time'
            ? timeSpent
            : state.timerModel.totalTimeSpent,
      ),
    );
  }

  // Get cycles count based on selected timeline
  int getBreakModeCyclesCount() {
    switch (state.selectedTimeline) {
      case 'Today':
        return state.timerModel.cyclesToday;
      case 'This Week':
        return state.timerModel.cyclesThisWeek;
      case 'This Month':
        return state.timerModel.cyclesThisMonth;
      case 'Total Time':
        return state.timerModel.totalCycles;
      default:
        return 0;
    }
  }

  // Get time spent based on selected timeline in HH:MM format
  String getBreakModeTimeSpent() {
    int timeSpent;
    switch (state.selectedTimeline) {
      case 'Today':
        timeSpent = state.timerModel.timeSpentToday;
        break;
      case 'This Week':
        timeSpent = state.timerModel.timeSpentThisWeek;
        break;
      case 'This Month':
        timeSpent = state.timerModel.timeSpentThisMonth;
        break;
      case 'Total Time':
        timeSpent = state.timerModel.totalTimeSpent;
        break;
      default:
        timeSpent = 0;
    }
    // Show time spent in HH:MM format
    final hours = (timeSpent ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((timeSpent % 3600) ~/ 60).toString().padLeft(2, '0');
    return '$hours : $minutes';
  }

  // Update the selected timeline in the state
  Future<void> updateSelectedTimeline(String timeline) async {
    state = state.copyWith(selectedTimeline: timeline);

    await fetchBreakModeData(
        timeline); // Fetch and update data for the new selected from bottomsheet timeline
  }
}

/// Provider for managing the state of the break timer.
final breakTimerProvider =
    NotifierProvider<BreakTimerViewModel, TimerState>(BreakTimerViewModel.new);

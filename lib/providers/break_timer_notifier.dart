import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_streak/data/database_helper.dart';

import 'package:pomodoro_streak/model/timer_state.dart';
import 'package:pomodoro_streak/services/notification_service.dart';

class BreakTimerNotifier extends Notifier<TimerState> {
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

  // starts the break timer and deliver notification after the timer ends
  void startBreakTimer() {
    if (state.isRunning) return; // Prevent starting a timer if already running

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.breakTime > 0) {
        state = state.copyWith(
          breakTime: state.breakTime - 1,
          isRunning: true,
        );
      } else {
        timer.cancel();
        completeBreakPomodoroSession(); // Update cycle and time spent
        resetBreakTimer(); // Reset the break timer when it ends
        NotificationService().showNotification(
            title: 'PomodoroStreak', body: 'Pomodoro session Finished');
      }
    });
    state = state.copyWith(isRunning: true);
  }

  // pauses the timer
  void pauseBreakTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false, isPaused: true);
  }

  // resumes the timer after pausing it
  void resumeBreakTimer() {
    if (!state.isPaused) return;
    startBreakTimer(); // Resume the timer
    state = state.copyWith(isPaused: false);
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

  void toggleBreakMode() {
    // Prevent switching modes if the timer is running or paused
    if (state.isRunning || state.isPaused) {
      return;
    }

    // Cancel the current break timer
    _timer?.cancel();

    // Switch mode to focus timer
    state = state.copyWith(
      isFocusMode: false,
      focusTime: state.breakTime, // Keep current break time
      isRunning: false,
      breakTime: state.defaultBreakTimeOption * 60, // Reset Break time
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

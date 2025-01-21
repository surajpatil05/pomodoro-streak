import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomodoro_streak/providers/break_timer_notifier.dart';
import 'package:pomodoro_streak/providers/focus_timer_notifier.dart';
import 'package:pomodoro_streak/providers/focus_break_mode_toggle_notifier.dart';

import 'package:pomodoro_streak/screens/break_mode_widget.dart';
import 'package:pomodoro_streak/screens/focus_mode_widget.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the state of focusBreakModeProvider (boolean state)
    // to determine if the current mode is Focus Mode (true) or Break Mode (false)
    final isFocusMode = ref.watch(focusBreakModeProvider);

    // Reads the notifier for focusBreakModeProvider to access its methods
    // which allow toggling between Focus Mode and Break Mode
    final focusBreakModeNotifier =
        ref.read(focusBreakModeProvider.notifier); // Access the notifier

    // Access the appropriate timer state based on the current mode (Focus or Break)
    final timerState = isFocusMode
        ? ref.watch(focusTimerProvider)
        : ref.watch(breakTimerProvider);
    final timerNotifier = isFocusMode
        ? ref.read(focusTimerProvider.notifier)
        : ref.read(breakTimerProvider.notifier);

    // Toggle the focus/break mode based on the current state
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: timerState.isRunning || timerState.isPaused
                    ? null
                    : () {
                        focusBreakModeNotifier.setFocusMode();
                      },
                child: Text(
                  'Focus',
                  style: TextStyle(
                    color: isFocusMode ? Colors.white : Colors.grey,
                    fontSize: 35,
                  ),
                ),
              ),
              TextButton(
                onPressed: timerState.isRunning || timerState.isPaused
                    ? null
                    : () {
                        focusBreakModeNotifier.setBreakMode();
                      },
                child: Text(
                  'Break',
                  style: TextStyle(
                    color: !isFocusMode ? Colors.white : Colors.grey,
                    fontSize: 35,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (timerState.isRunning || timerState.isPaused)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: IconButton(
                icon: Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  if (isFocusMode) {
                    (timerNotifier as FocusTimerNotifier)
                        .resetFocusTimer(); // reset focus timer
                  } else {
                    (timerNotifier as BreakTimerNotifier)
                        .resetBreakTimer(); // reset break timer
                  }
                },
              ),
            ),
        ],
      ),
      body: isFocusMode ? const FocusModeWidget() : const BreakModeWidget(),
    );
  }
}

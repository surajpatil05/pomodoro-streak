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
          // Show about dialog button when the timer is not running or paused
          if (!(timerState.isRunning || timerState.isPaused))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: IconButton(
                icon: Icon(
                  Icons.help_outline_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  // Show the dialog when the help button is pressed
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        insetPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical:
                                50), // Adds space from top to show below app bar
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Suggestions',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .white, // White text color for contrast
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Pomodoro',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // White text color
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "The Pomodoro Technique helps you use your time more efficiently by breaking your work into manageable intervals. "
                                  "You focus for 25 minutes, followed by a 5-minute break. These intervals, called 'pomodoros,' repeat throughout your workday. "
                                  "The technique is simple but powerful, and when combined with a timer like Pomodoro Streak, it can significantly boost your productivity and keep you on track.",
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                    height:
                                        16), // Space between Pomodoro and Meditation info
                                Text(
                                  'Meditation',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Meditation has been proven to reduce stress, improve focus, and enhance overall well-being. "
                                  "It doesn’t have to be complicated—just a few minutes of mindfulness can make a big difference. "
                                  "At Pomodoro Streak, we recommend starting with these 3 simple steps:\n\n"
                                  "1. Set the timer to 5 minutes.\n"
                                  "2. Close your eyes, take a deep breath, and relax.\n"
                                  "3. Focus on your breath and let any thoughts drift away.",
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 16), // Space before OK button
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      overlayColor: Colors.transparent,
                                      textStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text(
                                      'OK',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

          // Show cancel button when the timer is running or paused
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

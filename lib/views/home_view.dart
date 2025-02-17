import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pomodoro_streak/viewmodels/break_timer_viewmodel.dart';
import 'package:pomodoro_streak/viewmodels/focus_timer_viewmodel.dart';
import 'package:pomodoro_streak/viewmodels/toggle_focusbreak_mode_viewmodel.dart';

import 'package:pomodoro_streak/widgets/break_mode_widget.dart';
import 'package:pomodoro_streak/widgets/focus_mode_widget.dart';
import 'package:vibration/vibration.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the state of focusBreakModeProvider (boolean state)
    // to determine if the current mode is Focus Mode (true) or Break Mode (false)
    final isFocusMode = ref.watch(toggleFocusBreakModeProvider);

    // used to toggle between Focus Mode and Break Mode
    final toggleModeNotifier =
        ref.read(toggleFocusBreakModeProvider.notifier); // Access the notifier

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
          padding: EdgeInsets.all(8.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: timerState.isRunning || timerState.isPaused
                    ? null
                    : () {
                        if (Platform.isAndroid) {
                          // Haptic Feedback on tapped
                          Vibration.vibrate(duration: 50);
                        }
                        toggleModeNotifier.setFocusMode();
                      },
                child: Text(
                  'Focus',
                  style: TextStyle(
                    color: isFocusMode ? Colors.white : Colors.grey,
                    fontSize: 35.sp,
                  ),
                ),
              ),
              TextButton(
                onPressed: timerState.isRunning || timerState.isPaused
                    ? null
                    : () {
                        if (Platform.isAndroid) {
                          // Haptic Feedback on tapped
                          Vibration.vibrate(duration: 50);
                        }
                        toggleModeNotifier.setBreakMode();
                      },
                child: Text(
                  'Break',
                  style: TextStyle(
                    color: !isFocusMode ? Colors.white : Colors.grey,
                    fontSize: 35.sp,
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: IconButton(
                icon: Icon(
                  Icons.help_outline_outlined,
                  color: Colors.white,
                  size: 25.sp,
                ),
                onPressed: () {
                  if (Platform.isAndroid) {
                    // Haptic Feedback on tapped
                    Vibration.vibrate(duration: 50);
                  }
                  // Show the dialog when the help button is pressed
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        insetPadding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 50.h,
                        ), // Adds space from top to show below app bar
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Suggestions',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .white, // White text color for contrast
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Pomodoro',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // White text color
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "The Pomodoro Technique helps you use your time more efficiently by breaking your work into manageable intervals. "
                                  "You focus for 25 minutes, followed by a 5-minute break. These intervals, called 'pomodoros,' repeat throughout your workday. "
                                  "The technique is simple but powerful, and when combined with a timer like Pomodoro Streak, it can significantly boost your productivity and keep you on track.",
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                SizedBox(
                                  height: 16.h,
                                ), // Space between Pomodoro and Meditation info
                                Text(
                                  'Meditation',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Meditation has been proven to reduce stress, improve focus, and enhance overall well-being. "
                                  "It doesn’t have to be complicated—just a few minutes of mindfulness can make a big difference. "
                                  "At Pomodoro Streak, we recommend starting with these 3 simple steps:\n\n"
                                  "1. Set the timer to 5 minutes.\n"
                                  "2. Close your eyes, take a deep breath, and relax.\n"
                                  "3. Focus on your breath and let any thoughts drift away.",
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                SizedBox(
                                  height: 16.h,
                                ), // Space before OK button
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      overlayColor: Colors.transparent,
                                      textStyle: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (Platform.isAndroid) {
                                        // Haptic Feedback on tapped
                                        Vibration.vibrate(duration: 30);
                                      }
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
          if ((timerState.isRunning || timerState.isPaused) &&
              !timerState.isStarting)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: IconButton(
                icon: Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                  size: 25.sp,
                ),
                onPressed: () async {
                  if (Platform.isAndroid) {
                    // Haptic Feedback on tapped
                    Vibration.vibrate(duration: 100);
                  }
                  if (isFocusMode) {
                    (timerNotifier as FocusTimerViewModel)
                        .resetFocusTimer(); // reset focus timer
                  } else {
                    (timerNotifier as BreakTimerViewModel)
                        .resetBreakTimer(); // reset break timer
                  }
                },
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // For larger screens (like tablets), display the widget based on the current mode.
            return isFocusMode
                ? const FocusModeWidget()
                : const BreakModeWidget();
          } else {
            // For smaller screens (mobile), display the widget based on the current mode.
            return isFocusMode
                ? const FocusModeWidget()
                : const BreakModeWidget();
          }
        },
      ),
    );
  }
}

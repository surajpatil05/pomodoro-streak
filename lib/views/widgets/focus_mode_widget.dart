import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pomodoro_streak/viewmodels/focus_timer_viewmodel.dart';
import 'package:pomodoro_streak/viewmodels/timeline_selection_viewmodel.dart';

import 'package:pomodoro_streak/views/widgets/timeline_bottom_sheet_widget.dart';

class FocusModeWidget extends ConsumerStatefulWidget {
  const FocusModeWidget({super.key});

  @override
  ConsumerState<FocusModeWidget> createState() => _FocusModeWidgetState();
}

class _FocusModeWidgetState extends ConsumerState<FocusModeWidget> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => ref.read(focusTimerProvider.notifier).resetFocusTimeOption(),
    );

    // Ensure ref is used inside addPostFrameCallback to avoid early access
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final focusTimerNotifier = ref.read(focusTimerProvider.notifier);
        final defaultTimeline = ref.read(focusTimerProvider).selectedTimeline;

        focusTimerNotifier.fetchFocusModeData(defaultTimeline);
        syncWithFocusTimer(ref); // Sync dropdown with focusTimerProvider
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Provider to update pomodoro timer value when timer starts
    final focusModeTimerState = ref.watch(focusTimerProvider);

    // Provider to triggers actions such as (startFocusTimer, pauseFocusTimer, resumeFocusTimer) and update the timeSpent and cyclesCount values
    final focusModeTimerActions = ref.read(focusTimerProvider.notifier);

    // Provider to get the selected bottom sheet option
    String selectedFocusModeTimeline = ref.watch(timelineSelectionProvider);

    // Format time as MM:SS of pomodoro timer session
    String formatTime(int seconds) {
      final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
      final secs = (seconds % 60).toString().padLeft(2, '0');
      return '$minutes:$secs';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Top Row
        Padding(
          padding: EdgeInsets.all(20.r),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Left Column: Fire icon, 0 text, and Cycles text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 6.r),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.whatshot_sharp,
                          size: 30.sp,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          focusModeTimerActions
                              .getFocusModeCyclesCount()
                              .toString(), // display timeline time in hours and minutes
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.only(left: 12.r),
                    child: Row(
                      children: [
                        Text(
                          'Streak',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 38.h),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
              SizedBox(width: 40.w),

              // Right Column: Time text (0h 0min) and DropdownButton
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                        size: 30.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        focusModeTimerActions
                            .getFocusModeTimeSpent(), // display timeline time in hours and minutes

                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 70.w,
                        alignment: Alignment.bottomRight,
                        child: Text(
                          selectedFocusModeTimeline, // display selected timeline
                          softWrap: true,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          timelineBottomSheetWidget(
                              context, ref); // show the bottom sheet
                        },
                        icon: Icon(Icons.expand_more),
                        iconSize: 30.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 50.h),

        // Timer Display
        Text(
          formatTime(focusModeTimerState.timerModel.focusTime),
          style: TextStyle(
            fontSize: 70.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Time Selection Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [5, 15, 25, 60].map((time) {
            final isSelected =
                focusModeTimerState.selectedFocusTimeOption == time;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
              child: InkWell(
                onTap: focusModeTimerState.isRunning
                    ? null // Disable when timer is running
                    : () {
                        focusModeTimerActions.updateFocusTimeOption(time);
                      },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : const Color.fromARGB(255, 57, 57, 57),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    time.toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 60.h),

        // // Sound Dropdown FEATURE push in next update
        // Container(
        //   height: 45.h,
        //   width: 200.w,
        //   decoration: BoxDecoration(
        //     color: const Color.fromARGB(255, 57, 57, 57),
        //     borderRadius: BorderRadius.circular(10.r),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.all(8.r),
        //         child: Text(
        //           'Sound',
        //           style: TextStyle(fontSize: 16.sp),
        //         ),
        //       ),
        //       DropdownButton<String>(
        //         value: 'Default',
        //         underline: Container(),
        //         onChanged: timerState.isRunning ||
        //                 timerState.focusTime <
        //                     (timerState.defaultFocusTimeOption * 60)
        //             ? null
        //             : (String? newValue) {
        //                 // Handle sound selection
        //               },
        //         items: <String>['Default', 'Chime', 'Bell', 'Alert']
        //             .map<DropdownMenuItem<String>>((String value) {
        //           return DropdownMenuItem<String>(
        //             value: value,
        //             child: Text(value),
        //           );
        //         }).toList(),
        //       ),
        //     ],
        //   ),
        // ),

        SizedBox(height: 100.h),

        // Show Start button only if timer is not running, not starting, and not paused.
        if (!focusModeTimerState.isRunning &&
            focusModeTimerState.timerModel.focusTime ==
                focusModeTimerState.selectedFocusTimeOption * 60 &&
            !focusModeTimerState.isStarting &&
            !focusModeTimerState.isPaused)
          ElevatedButton(
            onPressed: () {
              focusModeTimerActions.startFocusTimer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
              textStyle:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            child: Transform.scale(
              scale: 1.3,
              child: const Text('START'),
            ),
          ),
        // Show the Pause button only if the timer is running, is Starting, and not in paused state.
        if ((focusModeTimerState.isStarting || focusModeTimerState.isRunning) &&
            (!focusModeTimerState.isPaused ||
                focusModeTimerState.timerModel.focusTime <=
                    (focusModeTimerState.selectedFocusTimeOption * 60)))
          ElevatedButton(
            onPressed: () {
              focusModeTimerActions.pauseFocusTimer();
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white, width: 2.w), // white border
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
              textStyle:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            child: Transform.scale(
              scale: 1.3,
              child: Text('PAUSE'),
            ),
          ),

        // show Resume Button only when the timer is paused not running and in the starting phase
        if ((!focusModeTimerState.isRunning ||
                focusModeTimerState.isStarting) &&
            focusModeTimerState.isPaused &&
            focusModeTimerState.timerModel.focusTime <=
                (focusModeTimerState.selectedFocusTimeOption * 60))
          ElevatedButton(
            onPressed: () {
              focusModeTimerActions.resumeFocusTimer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
              textStyle:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            child: Transform.scale(
              scale: 1.3,
              child: const Text('RESUME'),
            ),
          ),
      ],
    );
  }
}

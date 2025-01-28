import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pomodoro_streak/providers/focus_timer_notifier.dart';
import 'package:pomodoro_streak/providers/select_dropdown_notifier.dart';

import 'package:pomodoro_streak/utils/show_bottom_sheet_content.dart';

class FocusModeWidget extends ConsumerStatefulWidget {
  const FocusModeWidget({super.key});

  @override
  ConsumerState<FocusModeWidget> createState() => _FocusModeWidgetState();
}

class _FocusModeWidgetState extends ConsumerState<FocusModeWidget> {
  @override
  void initState() {
    super.initState();

    // Synchronize the dropdown value with focusTimerProvider after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final defaultTimeline = ref.read(focusTimerProvider).selectedTimeline;
      debugPrint('Fetching data for: $defaultTimeline');
      ref.read(focusTimerProvider.notifier).fetchFocusModeData(defaultTimeline);
      syncWithFocusTimer(ref); // Sync dropdown with focusTimerProvider
    });
  }

  // Sync function to update the dropdown state with focusTimerProvider
  void syncWithFocusTimer(WidgetRef ref) {
    // Get the selected focus timeline from focusTimerProvider
    final focusTimeline = ref.read(focusTimerProvider).selectedTimeline;

    // Update the selectDropDownProvider with the focusTimeline
    ref
        .read(selectDropDownProvider.notifier)
        .setHighlightedOption(focusTimeline);
  }

  @override
  Widget build(BuildContext context) {
    // Listen for changes in focusTimerProvider and update selectDropDownProvider
    ref.listen(focusTimerProvider, (_, selectedOption) async {
      final focusTimeline = selectedOption.selectedTimeline;

      // Update selectDropDownProvider if the selected timeline has changed
      if (ref.read(selectDropDownProvider) != focusTimeline) {
        debugPrint('Selected option changed to: $focusTimeline');

        ref
            .read(selectDropDownProvider.notifier)
            .setHighlightedOption(focusTimeline);

        // Fetch and update data for the selected timeline
        await ref
            .read(focusTimerProvider.notifier)
            .fetchFocusModeData(focusTimeline);
      }
    });

    // Provider to update the timeSpent and cyclesCount values
    final timerState = ref.watch(focusTimerProvider);

    // Provider to access FocusTimerNotifier functions
    final focusTimerNotifier = ref.read(focusTimerProvider.notifier);

    // Provider to get the selected dropdown option
    String selectedFocusTimeline = ref.watch(selectDropDownProvider);

    // Format time as MM:SS
    String formatTime(int seconds) {
      final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
      final secs = (seconds % 60).toString().padLeft(2, '0');
      return '$minutes:$secs';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Top Row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Left Column: Fire icon, 0 text, and Cycles text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 6.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.whatshot_sharp,
                        size: 30.sp,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        timerState
                            .getCyclesCount()
                            .toString(), // display timeline time in hours and minutes
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Row(
                    children: [
                      Text(
                        'Cycles',
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.watch_later_outlined,
                      size: 30.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      timerState
                          .formatTimeSpent(), // display timeline time in hours and minutes

                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 22.w),
                  child: Row(
                    children: [
                      Text(
                        selectedFocusTimeline, // display selected timeline
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showBottomSheetContent(
                              context, ref); // show the bottom sheet
                        },
                        icon: Icon(Icons.expand_more),
                        iconSize: 30.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 50.h),

        // Timer Display
        Text(
          formatTime(timerState.focusTime),
          style: TextStyle(
            fontSize: 70.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Time Selection Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [5, 15, 25, 60].map((time) {
            final isSelected = timerState.defaultFocusTimeOption == time;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
              child: InkWell(
                onTap: timerState.isRunning ||
                        timerState.focusTime <
                            (timerState.defaultFocusTimeOption * 60)
                    ? null // Disable when timer is running
                    : () {
                        focusTimerNotifier.updateFocusTimeOption(time);
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

        // Start Button
        if (!timerState.isRunning &&
            timerState.focusTime == timerState.defaultFocusTimeOption * 60)
          ElevatedButton(
            onPressed: () {
              focusTimerNotifier.startFocusTimer();
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

        // Pause Button
        if (timerState.isRunning && !timerState.isPaused)
          ElevatedButton(
            onPressed: () {
              focusTimerNotifier.pauseFocusTimer();
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
              child: const Text('PAUSE'),
            ),
          ),

        // Resume Button
        if (!timerState.isRunning &&
            timerState.isPaused &&
            timerState.focusTime < (timerState.defaultFocusTimeOption * 60))
          ElevatedButton(
            onPressed: () {
              focusTimerNotifier.resumeFocusTimer();
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

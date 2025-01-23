import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomodoro_streak/providers/break_timer_notifier.dart';
import 'package:pomodoro_streak/providers/select_dropdown_notifier.dart';

import 'package:pomodoro_streak/utils/show_bottom_sheet_content.dart';

class BreakModeWidget extends ConsumerStatefulWidget {
  const BreakModeWidget({super.key});

  @override
  ConsumerState<BreakModeWidget> createState() => _BreakModeWidgetState();
}

class _BreakModeWidgetState extends ConsumerState<BreakModeWidget> {
  @override
  void initState() {
    super.initState();

    // Synchronize the dropdown value with focusTimerProvider after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(breakTimerProvider.notifier).fetchBreakModeData('Today');
      syncWithBreakTimer(ref); // Sync dropdown with focusTimerProvider
    });
  }

  // Synchronize the dropdown value with focusTimerProvider after the widget is built
  void syncWithBreakTimer(WidgetRef ref) {
    // Get the selected focus timeline from focusTimerProvider
    final breakTimeline = ref.read(breakTimerProvider).selectedTimeline;

    // Update the selectDropDownProvider with the focusTimeline
    ref
        .read(selectDropDownProvider.notifier)
        .setHighlightedOption(breakTimeline);
  }

  @override
  Widget build(BuildContext context) {
    // Provider to update the timeSpent and cyclesCount values
    final timerState = ref.watch(breakTimerProvider);

    // Provider to access FocusTimerNotifier functions
    final breakTimerNotifier = ref.read(breakTimerProvider.notifier);

    // Provider to get the selected dropdown option
    String selectedBreakTimeline = ref.watch(selectDropDownProvider);

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
                  padding: const EdgeInsets.only(left: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sync,
                        size: 30,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 4),
                      Text(
                        timerState
                            .getCyclesCount()
                            .toString(), // display timeline time in hours and minutes
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Text(
                        'Cycles',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 38),
                    ],
                  ),
                ),
                SizedBox(height: 1),
              ],
            ),
            SizedBox(width: 40),

            // Right Column: Time text (0h 0min) and DropdownButton
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.watch_later_outlined,
                      size: 30,
                    ),
                    SizedBox(width: 4),
                    Text(
                      timerState
                          .formatTimeSpent(), // display timeline time in hours and minutes
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Row(
                    children: [
                      Text(
                        selectedBreakTimeline, // display selected timeline
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showBottomSheetContent(
                              context, ref); // show bottom sheet
                        },
                        icon: Icon(Icons.expand_more),
                        iconSize: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 50),

        // Timer Display
        Text(
          formatTime(timerState.breakTime),
          style: TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Time Selection Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [1, 5, 15, 30].map((time) {
            final isSelected = timerState.defaultBreakTimeOption == time;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
              child: InkWell(
                onTap: timerState.isRunning ||
                        timerState.breakTime <
                            (timerState.defaultBreakTimeOption * 60)
                    ? null // Disable when timer is running
                    : () {
                        breakTimerNotifier.updateBreakTimeOption(time);
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 60),

        // // Sound Dropdown
        // Container(
        //   height: 45,
        //   width: 200,
        //   decoration: BoxDecoration(
        //     color: const Color.fromARGB(255, 57, 57, 57),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Text(
        //           'Sound',
        //           style: TextStyle(fontSize: 16),
        //         ),
        //       ),
        //       DropdownButton<String>(
        //         value: 'Default',
        //         underline: Container(),
        //         onChanged: timerState.isRunning ||
        //                 timerState.breakTime <
        //                     (timerState.defaultBreakTimeOption * 60)
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

        SizedBox(height: 100),

        // Start Button
        if (!timerState.isRunning &&
            timerState.breakTime == timerState.defaultBreakTimeOption * 60)
          ElevatedButton(
            onPressed: () {
              breakTimerNotifier.startBreakTimer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
              breakTimerNotifier.pauseBreakTimer();
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white, width: 2),
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            child: Transform.scale(
              scale: 1.3,
              child: const Text('PAUSE'),
            ),
          ),

        // Resume Button
        if (!timerState.isRunning &&
            timerState.isPaused &&
            timerState.breakTime < (timerState.defaultBreakTimeOption * 60))
          ElevatedButton(
            onPressed: () {
              breakTimerNotifier.resumeBreakTimer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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

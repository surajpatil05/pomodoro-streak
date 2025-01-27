// custom_bottom_sheet.dart
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pomodoro_streak/providers/break_timer_notifier.dart';
import 'package:pomodoro_streak/providers/focus_timer_notifier.dart';

import 'package:pomodoro_streak/providers/select_dropdown_notifier.dart';

void showBottomSheetContent(BuildContext context, WidgetRef ref) {
  final options = ['Today', 'This Week', 'This Month', 'Total Time'];

  // Read the current selected option from the dropdown provider
  final selectedTimeline = ref.read(selectDropDownProvider);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (context) {
      return Container(
        height: 300.h,
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Option',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == selectedTimeline;

                  return GestureDetector(
                    onTap: () {
                      // Update selected option in bottomsheet dropdown and highlight it
                      ref
                          .read(selectDropDownProvider.notifier)
                          .setHighlightedOption(option);

                      // Notify FocusTimerNotifier about the timeline change
                      ref
                          .read(focusTimerProvider.notifier)
                          .updateSelectedTimeline(option);

                      // Notify BreakTimerNotifier about the timeline change
                      ref
                          .read(breakTimerProvider.notifier)
                          .updateSelectedTimeline(option);

                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 16.w),
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isSelected ? Colors.white : Colors.grey[400],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

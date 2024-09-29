import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';


class CalendarDayWidget extends StatelessWidget {
  CalendarDayWidget({
    super.key,
    required this.date,
    required this.enabled,
    required this.selected,
    required this.onTap,
    required this.applyBorder,
    this.hasEvents = false,
    this.height,
    this.showEventHint,
  });

  final DateTime date;
  final bool enabled;
  final bool selected;
  final bool applyBorder;
  final bool hasEvents;
  final double? height;
  final VoidCallback onTap;
  bool? showEventHint;

  @override
  Widget build(BuildContext context) {
    bool isToday = DateUtils.isSameDay(date, DateTime.now());

    if (isToday == false) {
      isToday = selected;
      DateTime twoDaysAhead = DateTime.now().add(const Duration(days: 2));
      showEventHint = date.isAfter(twoDaysAhead);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        height: 30.h,
        width: 30.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: isToday ? AppColors.calendarMonthText : Colors.transparent),
        child: enabled
            ? InkWell(
                onTap: onTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${date.day}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: isToday
                                  ? AppColors.whiteColor
                                  : AppColors.calendarWeekDay,
                            ),
                          ),
                          Container(
                            height: 3.w,
                            width: 3.h,
                            decoration: isToday || showEventHint!
                                ? const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red)
                                : const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(
          child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                color:isToday? AppColors.whiteColor:AppColors.calendarWeekDay,
              )

          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/providers/calender_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/views/drawer/calender/custom_calendar_view/src/day_view/day_view.dart';
import 'package:o_connect/ui/views/drawer/calender/custom_calendar_view/src/enumerations.dart';
import 'package:o_connect/ui/views/drawer/calender/custom_calendar_view/src/modals.dart';
import 'package:o_connect/ui/views/drawer/calender/events_modalsheet.dart';
import 'package:o_connect/ui/views/drawer/calender/widgets/events_popup.dart';
import 'package:provider/provider.dart';

class DayCalender extends StatefulWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const DayCalender({super.key, this.state, this.width});

  @override
  State<DayCalender> createState() => _DayCalenderState();
}

class _DayCalenderState extends State<DayCalender> {
  late CalenderProvider cp;

  @override
  void initState() {
    cp = Provider.of<CalenderProvider>(context, listen: false);
    // cp.fetchEventsInDay(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalenderProvider>(builder: (context, value, child) {
      return Column(
        children: [
          EventsButton(text: DateFormat("EEE, dd MMM, yyyy").format(DateTime.parse(cp.onPageChangeDate))),
          height5,
          // value.events != null && value.events.isNotEmpty ?
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.68,
            width: ScreenConfig.width,
            child: DayView(
                minDay: DateTime.parse(cp.onPageChangeDate),
                maxDay: DateTime.parse(cp.onPageChangeDate),
                initialDay: DateTime.parse(cp.onPageChangeDate),
                controller: value.dayController,
                liveTimeIndicatorSettings: const HourIndicatorSettings(
                  color: Colors.red,
                ),
                key: widget.state,
                width: widget.width,
                startDuration: const Duration(hours: 8),
                showHalfHours: true,
                heightPerMinute: 0.8,
                timeLineBuilder: _timeLineBuilder,
                timeLineWidth: 60.w,
                hourIndicatorSettings: const HourIndicatorSettings(color: Colors.black, height: 2),
                onPageChange: (date, page) async {
                  if (DateTime.parse(value.onPageChangeDate).month != date.month) {
                    value.onPageChangeDate = date.toString();
                    value.setStartEnd();
                    await value.fetchEventsInDay(context);
                  } else {
                    value.onPageChangeDate = date.toString();
                  }
                  value.callNotify();
                },
                // halfHourIndicatorSettings: HourIndicatorSettings(
                //   color: Theme.of(context).dividerColor,
                //   lineStyle: LineStyle.dashed,
                // ),
                // fullDayEventBuilder: (events, date) {
                //   return const SizedBox();
                // },
                // dayTitleBuilder: (date) {
                //   return const IgnorePointer();
                // },
                onEventTap: (events, date) {
                  customShowDialog(context, EventsModalSheet(events: events.first), color: Theme.of(context).cardColor);
                }),
          )
          // :const Center(child: CircularProgressIndicator())
        ],
      );
    });
  }
}

Widget _timeLineBuilder(DateTime date) {
  if (date.minute != 0) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: -8,
          right: 8,
          child: Text(
            "${date.hour}:${date.minute}",
            textAlign: TextAlign.right,
            style: const TextStyle(color: LightThemeColors.greyTextColor),
          ),
        ),
      ],
    );
  }

  final hour = ((date.hour - 1) % 12) + 1;

  return Stack(
    clipBehavior: Clip.none,
    children: [
      Positioned.fill(
          top: 15,
          right: 7,
          child: Text(
            "$hour ${date.hour ~/ 12 == 0 ? "AM" : "PM"}",
            textAlign: TextAlign.right,
            style: const TextStyle(color: LightThemeColors.greyTextColor),
          )),
    ],
  );
}

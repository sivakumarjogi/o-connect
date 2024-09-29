import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/providers/calender_provider.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/views/drawer/calender/custom_calendar_view/src/modals.dart';
import 'package:o_connect/ui/views/drawer/calender/custom_calendar_view/src/week_view/week_view.dart';
import 'package:o_connect/ui/views/drawer/calender/events_modalsheet.dart';
import 'package:o_connect/ui/views/drawer/calender/widgets/events_popup.dart';
import 'package:provider/provider.dart';

class WeekCalender extends StatefulWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;

  const WeekCalender({super.key, this.state, this.width});

  @override
  State<WeekCalender> createState() => _WeekCalenderState();
}

class _WeekCalenderState extends State<WeekCalender> {
  late CalenderProvider cProvider;

  @override
  void initState() {
    cProvider = Provider.of<CalenderProvider>(context, listen: false);
    // cProvider.fetchEventsInDay(context);
    super.initState();
    formatDate();
  }

  String formatDate({String? date}) {
    DateTime dateTime = DateTime.parse(cProvider.onPageChangeDate);
    int weekNumber = calculateWeekNumber(dateTime);
    String formattedDate = '$weekNumber${getWeekSuffix(weekNumber)} week, ${DateFormat("MMMM, y").format(dateTime)}';
    return formattedDate;
  }

  int calculateWeekNumber(DateTime dateTime) {
    final firstDayOfYear = DateTime(dateTime.year, dateTime.month, 1);
    final daysDifference = dateTime.difference(firstDayOfYear).inDays;
    return (daysDifference ~/ 7) + 1;
  }

  String getWeekSuffix(int weekNumber) {
    if (weekNumber >= 11 && weekNumber <= 13) {
      return 'th';
    }
    switch (weekNumber % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalenderProvider>(
      builder: (context, value, child) {
        return Column(
          children: [
            EventsButton(text: formatDate()),
            height5,
            // value.events != null && value.events.isNotEmpty ?
            SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.67,
                child: WeekView(
                  minDay: DateTime.parse(value.onPageChangeDate),
                  maxDay: DateTime.parse(value.onPageChangeDate),
                  initialDay: DateTime.parse(value.onPageChangeDate),
                  liveTimeIndicatorSettings: const HourIndicatorSettings(
                    color: Colors.red,
                  ),
                  hourIndicatorSettings: const HourIndicatorSettings(color: Colors.black, height: 1.5),
                  controller: value.dayController,
                  key: widget.state,
                  width: widget.width,
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
                  onEventTap: (events, date) {
                    customShowDialog(
                        context,
                        EventsModalSheet(
                          events: events.first,
                        ));
                  },
                ))
            // :const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}

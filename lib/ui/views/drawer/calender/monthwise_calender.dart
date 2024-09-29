import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/providers/calender_provider.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/custom_show_dialog_helper/custom_show_dialog.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/views/drawer/calender/custom_calendar_view/src/month_view/month_view.dart';
import 'package:o_connect/ui/views/drawer/calender/events_modalsheet.dart';
import 'package:o_connect/ui/views/drawer/calender/widgets/events_popup.dart';
import 'package:o_connect/ui/views/drawer/calender/custom_calendar_view/src/calendar_event_data.dart';
import 'package:o_connect/ui/views/meeting/utils/context_ext.dart';

import 'package:provider/provider.dart';

class MonthWiseCalender extends StatefulWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;

  const MonthWiseCalender({super.key, this.state, this.width});

  @override
  State<MonthWiseCalender> createState() => _MonthWiseCalenderState();
}

class _MonthWiseCalenderState extends State<MonthWiseCalender> {
  late CalenderProvider cProvider;

  @override
  void initState() {
    cProvider = Provider.of<CalenderProvider>(context, listen: false);
    // cProvider.fetchEventsInDay(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalenderProvider>(builder: (context, value, child) {
      return Column(
        children: [
          EventsButton(
            text: DateFormat("MMMM, yyyy").format(DateTime.parse(value.onPageChangeDate)),
          ),
          height5,
          // value.events != null && value.events.isNotEmpty ?
          SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.68,
              child: MonthView(
                  minMonth: DateTime(DateTime.parse(value.onPageChangeDate).year, DateTime.parse(value.onPageChangeDate).month, 01),
                  maxMonth: DateTime(DateTime.parse(value.onPageChangeDate).year, DateTime.parse(value.onPageChangeDate).month,
                      value.getLastDayOfMonth(DateTime.parse(value.onPageChangeDate).year, DateTime.parse(value.onPageChangeDate).month)),
                  initialMonth: DateTime.parse(value.onPageChangeDate),
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
                  onCellTap: (events, date) {
                    if (events.isNotEmpty) {
                      customShowDialog(
                        context,
                        _EventsPopup(events: events),
                        color: Theme.of(context).cardColor,
                      );
                    }
                  }))
          // :const Center(child: CircularProgressIndicator())
        ],
      );
    });
  }
}

@immutable
class Events {
  final String title;

  const Events({this.title = "Title"});

  @override
  bool operator ==(Object other) => other is Events && title == other.title;

  @override
  String toString() => title;
}

class _EventsPopup extends StatelessWidget {
  const _EventsPopup({required this.events});

  final List<CalendarEventData> events;

  @override
  Widget build(BuildContext context) {
    var listView = ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: events.length,
      itemBuilder: (context, index) => EventCard(events: events[index]),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        showDialogCustomHeader(context, headerTitle: "Events"),
        SizedBox(
          height: ScreenConfig.height * 0.3,
          child: listView,
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Close",
              style: w500_14Poppins(color: AppColors.mainBlueColor),
            ))
      ],
    );
  }
}

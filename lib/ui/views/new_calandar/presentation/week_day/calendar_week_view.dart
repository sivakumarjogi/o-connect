import 'package:flutter/material.dart';
import 'package:oes_chatbot/utils/extensions/calendar_extensions.dart';
import 'package:provider/provider.dart';

import '../../../../../core/providers/calender_provider.dart';
import '../../model/calander_date_info.dart';

class CalendarWeekView extends StatefulWidget {
  const CalendarWeekView({
    super.key,
    required this.curDate,
    required this.dayBuilder,
  });

  final DateTime curDate;
  final Widget Function(CalendarDateInfo info) dayBuilder;

  @override
  State<CalendarWeekView> createState() => _CalendarWeekViewState();
}

class _CalendarWeekViewState extends State<CalendarWeekView> {
  bool isMonthChanged = false;

  late DragUpdateDetails detailsVar;

  late CalenderProvider cp;



  @override
  Widget build(BuildContext context) {
    cp = Provider.of<CalenderProvider>(context, listen: false);
    bool isTodayS=false;
    final endOffset =
        widget.curDate.weekday == 7 ? 0 : 7 - widget.curDate.weekday;
    final startOffset =
        widget.curDate.weekday == 1 ? 0 : widget.curDate.weekday - 1;

    final startDate = widget.curDate.subtract(Duration(days: startOffset + 1));
    final endDate = widget.curDate.add(Duration(days: endOffset));

    final List<Widget> dayWidgets = [];

    for (DateTime d = startDate;
        d.isBefore(endDate);
        d = d.add(const Duration(days: 1))) {
      final enabled = DateUtils.isSameMonth(widget.curDate, d);
      String applyBorder = "";
      if (cp.noDataFound! || cp.isLoadingDataCale!) {

      }else
        {
          for (var sss in cp.calenderMonthEvent!.events!) {
            if (sss.startTime.isSameDay(dateTime: d)) {
              applyBorder = sss.status;

              setState(() {});
            }
          }
        }

      if(cp.isSelected==false)
      {
        isTodayS= DateUtils.isSameDay(d, DateTime.now()) ;
      }

      final widget11 = Expanded(
          child: widget.dayBuilder(CalendarDateInfo(
              date: d, applyBorder: applyBorder, enabled: enabled,isToday:isTodayS )));
      dayWidgets.add(widget11);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //    const WeekdaysWidget(),
        //   4.height,
        GestureDetector(
            onHorizontalDragUpdate: (details) async {
              detailsVar = await details;
              isMonthChanged = false;
            },
            onHorizontalDragEnd: (details) {
              if (isMonthChanged == false) {
                isMonthChanged = true;
                if (detailsVar.delta.dx > 0) {
                  cp.changeDay(-1);
                  // Set flag to true
                } else if (detailsVar.delta.dx < 0) {
                  cp.changeDay(1);
                  print('Left swipe detected');
                }
              } // Reset flag when the gesture ends
            },
            onHorizontalDragStart: (details) {},
            /*   onHorizontalDragUpdate: (details) {
              if (isMonthChanged == false) {
                isMonthChanged = true;
                if (details.delta.dx > 0) {

                  cp.changeDay(-1);
                 // Set flag to true
                } else if (details.delta.dx < 0) {
                  cp.changeDay(1);
                  print('Left swipe detected');
                }
              }
            },
            onHorizontalDragEnd: (details) {
              isMonthChanged = false; // Reset flag when the gesture ends
            },
            onHorizontalDragStart: (details) {
             isMonthChanged = false;
            },*/
            child: SizedBox(height: 45, child: Row(children: dayWidgets))),
      ],
    );
  }
}

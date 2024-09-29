import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oes_chatbot/utils/extensions/calendar_extensions.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/calender_provider.dart';
import '../model/calander_config.dart';
import '../model/calander_date_info.dart';

class CalanderView extends StatefulWidget {
  CalanderView({
    super.key,
    required this.month,
    required this.builder,
    required this.config,
  });

  final DateTime month;
  final CalendarConfig config;
  final Widget Function(CalendarDateInfo info) builder;

  @override
  State<CalanderView> createState() => _CalanderViewState();
}

class _CalanderViewState extends State<CalanderView> {
  bool isMonthChanged = false;

  late DragUpdateDetails detailsVar;

  late CalenderProvider cp;



  @override
  Widget build(BuildContext context) {
    cp = Provider.of<CalenderProvider>(context, listen: false);
    bool isTodayS=false;
    final offset = DateUtils.firstDayOffset(widget.month.year,
        widget.month.month, MaterialLocalizations.of(context));
    final nextMonth = DateUtils.addMonthsToMonthDate(widget.month, 1);
    final endOffset = nextMonth.weekday == 7 ? 0 : 7 - nextMonth.weekday;
    final start = DateTime(widget.month.year, widget.month.month)
        .subtract(Duration(days: offset));
    final end = nextMonth.add(Duration(days: endOffset));

    final List<CalendarDateInfo> data = [];
    for (DateTime d = start;
        d.isBefore(end);
        d = d.add(const Duration(days: 1))) {
      final enabled = (d.isAfter(widget.config.minDate) &&
              d.isBefore(widget.config.maxDate)) ||
          DateUtils.isSameDay(d, widget.config.minDate);
      String applyBorder = "";

      if (cp.noDataFound! || cp.isLoadingDataCale!) {
      } else {

        if(cp.calenderMonthEvent!=null)
          {
            for (var sss in cp.calenderMonthEvent!.events!) {
              if (sss.startTime.isSameDay(dateTime: d)) {
                print("sss.status ${sss.status}");
                applyBorder = sss.status;
                setState(() {});
              }
            }
          }

      }

      if(cp.isSelected==false)
        {
          isTodayS= DateUtils.isSameDay(d, DateTime.now()) ;
        }

      data.add(CalendarDateInfo(
          date: d, applyBorder: applyBorder, enabled: enabled,isToday: isTodayS));
    }

  /*  for (int i = data.length - 1; i >= data.length - 7; i--) {
      data[i] = data[i].copyWith(applyBorder: "");
    }*/

    final children = data
        .map(
          (e) => GridTile(
        child: widget.builder(e),
          ),
    )
        .toList();
    print("data.lengt ${data!.length}");
    return GestureDetector(
      onHorizontalDragUpdate: (details) async {
        detailsVar = await details;
        isMonthChanged = false;
      },
      onHorizontalDragEnd: (details) {
        if (isMonthChanged == false) {
          isMonthChanged = true;
          if (detailsVar.delta.dx > 0) {
            cp.changeMonth(-1);
            // Set flag to true
          } else if (detailsVar.delta.dx < 0) {
            cp.changeMonth(1);
            print('Left swipe detected');
          }
        } // Reset flag when the gesture ends
      },
      onHorizontalDragStart: (details) {},
      child: SizedBox(
       height: data.length/7>5?330.h:260.h,
        child: GridView.custom(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 45,
            mainAxisSpacing: 4,
            crossAxisSpacing: 6,
          ),
          childrenDelegate: SliverChildListDelegate(children),
        ),
      ),
    );
  }
}
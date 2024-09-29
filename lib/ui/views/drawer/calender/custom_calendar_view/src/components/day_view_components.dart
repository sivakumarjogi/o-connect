// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/views/drawer/calender/events_modalsheet.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../calendar_event_data.dart';
import '../constants.dart';
import '../extensions.dart';
import '../style/header_style.dart';
import '../typedefs.dart';
import 'common_components.dart';

/// This class defines default tile to display in day view.
class RoundedEventTile extends StatelessWidget {
  /// Title of the tile.
  final String title;

  /// Description of the tile.
  final String description;

  /// Background color of tile.
  /// Default color is [Colors.blue]
  final Color backgroundColor;

  /// If same tile can have multiple events.
  /// In most cases this value will be 1 less than total events.
  final int totalEvents;

  /// Padding of the tile. Default padding is [EdgeInsets.zero]
  final EdgeInsets padding;

  /// Margin of the tile. Default margin is [EdgeInsets.zero]
  final EdgeInsets margin;

  /// Border radius of tile.
  final BorderRadius borderRadius;

  /// Style for title
  final TextStyle? titleStyle;

  /// Style for description
  final TextStyle? descriptionStyle;

  /// As this is common style, need to check day view or week view
  final bool isWeek;

  final DateTime startDateTime;

  final DateTime endDateTime;

  final dynamic image;

  final bool? hasOverlappingEvents;


  /// This is default tile to display in day view.
  const RoundedEventTile(
      {Key? key,
      required this.title,
      this.padding = EdgeInsets.zero,
      this.margin = EdgeInsets.zero,
      this.description = "",
      this.borderRadius = BorderRadius.zero,
      required this.totalEvents,
      this.backgroundColor = Colors.blue,
      this.titleStyle,
      this.descriptionStyle,
      this.isWeek = false,
        required this.startDateTime,
        required this.endDateTime,
        this.image,
         this.hasOverlappingEvents
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    Duration duration =  endDateTime.difference(startDateTime);

    return Container(
        decoration: BoxDecoration(
          color:Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: isWeek? Column(
          children: [
            if (title.isNotEmpty)
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: backgroundColor.accent,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            if (description.isNotEmpty)
              Text(
                description,
                style:
                const TextStyle(
                  fontSize: 14,
                  color: LightThemeColors.greyTextColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),

          ],
        ):Center(
          child: FittedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                hasOverlappingEvents!?
                Padding(
                  padding:  EdgeInsets.only(top:duration.inMinutes >= 60.h?10.0.h:3.0.h),
                  child: Text(
                    title??"",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: backgroundColor.accent,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ):(duration.inHours >= 1 || duration.inMinutes > 50)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageWithLogo(image,height:45.h,width: 45.h),
                    SizedBox(width: 10.w,),
                    Column(
                      children: [
                        if (title.isNotEmpty)
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14,
                              color: backgroundColor.accent,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (description.isNotEmpty)
                          Text(
                            description,
                            style:
                            const TextStyle(
                              fontSize: 14,
                              color: LightThemeColors.greyTextColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    )
                  ],
                ):  (title.isNotEmpty)?
                Padding(
                  padding:  EdgeInsets.only(top:duration.inMinutes >= 60?10.0:3.0),
                  child: Text(
                    title??"",
                    style: TextStyle(
                      fontSize: 14,
                      color: backgroundColor.accent,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ):const SizedBox()
    ],
            ),
          ),
        )
    );
  }
}

/// A header widget to display on day view.
class DayPageHeader extends CalendarPageHeader {
  /// A header widget to display on day view.
  const DayPageHeader({
    Key? key,
    VoidCallback? onNextDay,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousDay,
    Color iconColor = Constants.black,
    Color backgroundColor = Constants.headerBackground,
    StringProvider? dateStringBuilder,
    required DateTime date,
    HeaderStyle headerStyle = const HeaderStyle(),
  }) : super(
          key: key,
          date: date,
          // ignore_for_file: deprecated_member_use_from_same_package
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          onNextDay: onNextDay,
          onPreviousDay: onPreviousDay,
          onTitleTapped: onTitleTapped,
          dateStringBuilder:
              dateStringBuilder ?? DayPageHeader._dayStringBuilder,
          headerStyle: headerStyle,
        );

  static String _dayStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.day} - ${date.month} - ${date.year}";
}

class DefaultTimeLineMark extends StatelessWidget {
  /// Defines time to display
  final DateTime date;

  /// StringProvider for time string
  final StringProvider? timeStringBuilder;

  /// Text style for time string.
  final TextStyle? markingStyle;

  /// Time marker for timeline used in week and day view.
  const DefaultTimeLineMark({
    Key? key,
    required this.date,
    this.markingStyle,
    this.timeStringBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hour = ((date.hour - 1) % 12) + 1;
    final timeString = (timeStringBuilder != null)
        ? timeStringBuilder!(date)
        : date.minute != 0
            ? "$hour:${date.minute}"
            : "$hour ${date.hour ~/ 12 == 0 ? "AM" : "PM"}";
    return Transform.translate(
      offset: const Offset(0, -7.5),
      child: Padding(
        padding: const EdgeInsets.only(right: 7.0),
        child: Text(
          timeString,
          textAlign: TextAlign.right,
          style: markingStyle ??
              const TextStyle(
                fontSize: 15.0,
              ),
        ),
      ),
    );
  }
}

/// This class is defined default view of full day event
class FullDayEventView<T> extends StatelessWidget {
  const FullDayEventView({
    Key? key,
    this.boxConstraints = const BoxConstraints(maxHeight: 100),
    required this.events,
    this.padding,
    this.itemView,
    this.titleStyle,
    this.onEventTap,
    required this.date,
  }) : super(key: key);

  /// Constraints for view
  final BoxConstraints boxConstraints;

  /// Define List of Event to display
  final List<CalendarEventData<T>> events;

  /// Define Padding of view
  final EdgeInsets? padding;

  /// Define custom Item view of Event.
  final Widget Function(CalendarEventData<T>? event)? itemView;

  /// Style for title
  final TextStyle? titleStyle;

  /// Called when user taps on event tile.
  final TileTapCallback<T>? onEventTap;

  /// Defines date for which events will be displayed.
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: boxConstraints,
      child: ListView.builder(
        itemCount: events.length,
        padding: padding ?? EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) => InkWell(
          onTap: () => onEventTap?.call(events[index], date),
          child: itemView?.call(events[index]) ??
              Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(1.0),
                height: 24,
                child: Text(
                  events[index].name,
                  style: titleStyle ??
                      TextStyle(
                        fontSize: 16,
                        color: events[index].color.accent,
                      ),
                  maxLines: 1,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: events[index].color,
                ),
                alignment: Alignment.centerLeft,
              ),
        ),
      ),
    );
  }
}

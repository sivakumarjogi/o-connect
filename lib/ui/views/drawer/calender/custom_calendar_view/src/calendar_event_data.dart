// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'extensions.dart';

/// Stores all the events on [date]
@immutable
class CalendarEventData<T extends Object?> {
  /// Specifies date on which all these events are.
  final DateTime date;

  /// Defines the start time of the event.
  /// [endTime] and [startTime] will defines time on same day.
  /// This is required when you are using [CalendarEventData] for [DayView]
  final DateTime startTime;

  /// Defines the end time of the event.
  /// [endTime] and [startTime] defines time on same day.
  /// This is required when you are using [CalendarEventData] for [DayView]
  final DateTime endTime;

  /// Title of the event.
  final String name;

  /// Description of the event.
  final String description;

  /// Defines color of event.
  /// This color will be used in default widgets provided by plugin.
  final Color color;

  /// Event on [date].
  final T? event;

  final DateTime? _endDate;

  /// Define style of title.
  final TextStyle? titleStyle;

  /// Define style of description.
  final TextStyle? descriptionStyle;

  final String? status;

  final String? image;

  /// Stores all the events on [date]
  ///
  final String? id;
  const CalendarEventData(
      {this.id,
      required this.name,
      this.description = "",
      this.event,
      this.color = Colors.blue,
      required this.startTime,
      required this.endTime,
      this.titleStyle,
      this.descriptionStyle,
      DateTime? endDate,
      required this.date,
      this.status,
      this.image,
      })
      : _endDate = endDate;

  DateTime get endDate => _endDate ?? date;

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "startTime":startTime ,
        "endTime": endTime,
        "event": event,
        "title": name,
        "description": description,
        "endDate": endDate,
        "status": status,
        "image": image
      };

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) {
    return other is CalendarEventData<T> &&
        date.compareWithoutTime(other.date) &&
        endDate.compareWithoutTime(other.endDate) &&
        ((event == null && other.event == null) ||
            (event != null && other.event != null && event == other.event)) &&
        ((startTime == null && other.startTime == null) ||
            (startTime != null &&
                other.startTime != null &&
                startTime!.hasSameTimeAs(other.startTime!))) &&
        ((endTime == null && other.endTime == null) ||
            (endTime != null &&
                other.endTime != null &&
                endTime!.hasSameTimeAs(other.endTime!))) &&
        name == other.name &&
        color == other.color &&
        titleStyle == other.titleStyle &&
        descriptionStyle == other.descriptionStyle &&
        description == other.description &&
        status == other.status &&
        image == other.image &&
        id == other.id;
  }

  @override
  int get hashCode => super.hashCode;
}

import 'dart:ui';

class ChartData {
  ChartData({
    required this.eventName,
    required this.eventValue,
    required this.eventColor,
  });

  final String eventName;
  final double eventValue;
  final Color eventColor;
}


class ChartDatas {
  ChartDatas({
    required this.eventName,
    required  this.eventValue,
    required  this.numberOfParticipants,
  }
  );

  String eventName;
  int eventValue;
  int numberOfParticipants;
}

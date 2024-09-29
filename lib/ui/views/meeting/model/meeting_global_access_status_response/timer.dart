import 'dart:convert';

import 'package:equatable/equatable.dart';

class InitialTimer extends Equatable {
  final int userId;
  final String userName;
  final String time;
  final String timeMin;
  final String timeSec;
  final String remainingTimeLeft;
  final int oui;
  const InitialTimer({
    required this.userId,
    required this.userName,
    required this.time,
    required this.timeMin,
    required this.timeSec,
    required this.remainingTimeLeft,
    required this.oui,
  });

  @override
  List<Object> get props {
    return [
      userId,
      userName,
      time,
      timeMin,
      timeSec,
      remainingTimeLeft,
      oui,
    ];
  }

  factory InitialTimer.fromMap(Map<String, dynamic> map) {
    return InitialTimer(
      userId: map['userId']?.toInt() ?? 0,
      userName: map['user'] ?? '',
      time: map['time'] ?? '',
      timeMin: map['timeMin'] ?? '',
      timeSec: map['timeSec'] ?? '',
      remainingTimeLeft: map['remainingTimeLeft'] ?? '',
      oui: map['oui']?.toInt() ?? 0,
    );
  }

  factory InitialTimer.fromJson(String source) => InitialTimer.fromMap(json.decode(source));
}

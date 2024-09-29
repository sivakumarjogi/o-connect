import 'package:equatable/equatable.dart';

class EventStatus extends Equatable {
  final String? status;
  final DateTime? startTime;

  const EventStatus({this.status, this.startTime});

  factory EventStatus.fromJson(Map<String, dynamic> json) {
    return EventStatus(
      status: json['status'] as String?,
      startTime: json['startTime'] == null ? null : DateTime.parse(json['startTime'] as String),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      "startTime": startTime,
    };
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [status, startTime];
}

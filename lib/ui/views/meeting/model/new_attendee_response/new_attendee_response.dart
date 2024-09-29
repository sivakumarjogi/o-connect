import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'new_attendee_response.g.dart';

@JsonSerializable()
class NewAttendeeResponse extends Equatable {
  final bool? status;
  final AttendeeData? data;
  final String? message;
  final String? error;

  const NewAttendeeResponse({this.status, this.data, this.message, this.error});

  factory NewAttendeeResponse.fromJson(Map<String, dynamic> json) {
    return _$NewAttendeeResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NewAttendeeResponseToJson(this);

  NewAttendeeResponse copyWith({
    bool? status,
    AttendeeData? data,
    String? message,
  }) {
    return NewAttendeeResponse(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [status, data, message, error];
}

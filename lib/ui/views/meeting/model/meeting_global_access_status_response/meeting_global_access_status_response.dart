import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'meeting_global_access_status_response.g.dart';

@JsonSerializable()
class MeetingGlobalAccessStatusResponse extends Equatable {
  final bool? status;
  final Data? data;

  const MeetingGlobalAccessStatusResponse({this.status, this.data});

  factory MeetingGlobalAccessStatusResponse.fromJson(
      Map<String, dynamic> json) {
    return _$MeetingGlobalAccessStatusResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MeetingGlobalAccessStatusResponseToJson(this);
  }

  MeetingGlobalAccessStatusResponse copyWith({
    bool? status,
    Data? data,
  }) {
    return MeetingGlobalAccessStatusResponse(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [status, data];
}

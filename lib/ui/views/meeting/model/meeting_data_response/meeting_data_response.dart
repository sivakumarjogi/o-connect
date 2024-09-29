import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'meeting_data_response.g.dart';

@JsonSerializable()
class MeetingDataResponse extends Equatable {
  final bool? status;
  final MeetingData? data;

  const MeetingDataResponse({this.status, this.data});

  factory MeetingDataResponse.fromJson(Map<String, dynamic> json) {
    return _$MeetingDataResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MeetingDataResponseToJson(this);

  MeetingDataResponse copyWith({
    bool? status,
    MeetingData? data,
  }) {
    return MeetingDataResponse(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [status, data];
}

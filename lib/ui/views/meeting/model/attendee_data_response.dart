import 'package:equatable/equatable.dart';
import 'package:o_connect/ui/views/meeting/model/hub_user_data/hub_user_data.dart';

class AttendeeDataResponse extends Equatable {
  final bool? status;
  final List<HubUserData>? data;

  const AttendeeDataResponse({this.status, this.data});

  factory AttendeeDataResponse.fromJson(Map<String, dynamic> json) {
    return AttendeeDataResponse(
      status: json['status'] as bool?,
      data: (json['data'] as List<dynamic>)
          .map((e) => HubUserData.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [status, data];
}

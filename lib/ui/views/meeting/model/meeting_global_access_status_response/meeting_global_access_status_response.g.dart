// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_global_access_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingGlobalAccessStatusResponse _$MeetingGlobalAccessStatusResponseFromJson(
        Map<String, dynamic> json) =>
    MeetingGlobalAccessStatusResponse(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MeetingGlobalAccessStatusResponseToJson(
        MeetingGlobalAccessStatusResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

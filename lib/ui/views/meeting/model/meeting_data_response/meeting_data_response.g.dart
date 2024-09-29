// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingDataResponse _$MeetingDataResponseFromJson(Map<String, dynamic> json) =>
    MeetingDataResponse(
      status: json['status'] as bool?,
      data: json['data'] == null
          ? null
          : MeetingData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MeetingDataResponseToJson(
        MeetingDataResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

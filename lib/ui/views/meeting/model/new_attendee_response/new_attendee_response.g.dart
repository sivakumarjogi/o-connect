// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_attendee_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewAttendeeResponse _$NewAttendeeResponseFromJson(Map<String, dynamic> json) => NewAttendeeResponse(
      status: json['status'] as bool?,
      data: json['data'] == null ? null : AttendeeData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$NewAttendeeResponseToJson(NewAttendeeResponse instance) => <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
      'error': instance.error,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendeeData _$DataFromJson(Map<String, dynamic> json) => AttendeeData(
    id: json['_id'] as String?,
    participantName: json['participant_name'] as String?,
    participantEmail: json['participant_email'] as String?,
    meetingId: json['meeting_id'] as String?,
    userId: json['user_id'] as int?,
    meetingName: json['meeting_name'] as String?,
    country: json['country'] as String?,
    joinTime: json['join_time'] == null ? null : DateTime.parse(json['join_time'] as String),
    leaveTime: json['leave_time'],
    roleType: json['role_type'] as String?,
    limitReached: json['limitReached'] as bool?,
    speakerLimitReached: json['speakerLimitReached'] as bool?,
    guestLimitReached: json['guestLimitReached'] as bool?,
    loop: json['loop'] as int?,
    isMeetingLocked: json['is_meeting_locked'] as bool?,
    activeHost: json['active_host'] as bool?,
    isBlocked: json['is_blocked'] as int?);

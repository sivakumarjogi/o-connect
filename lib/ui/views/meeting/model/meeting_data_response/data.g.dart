// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
MeetingData _$MeetingDataFromJson(Map<String, dynamic> json) => MeetingData(
      meetingName: json['meeting_name'] as String?,
      meetingPassword: json['meeting_password'] as String?,
      roomType: json['room_type'] as String?,
      meetingType: json['meeting_type'] as String?,
      meetingDate: json['meeting_date'] == null ? null : DateTime.parse(json['meeting_date'] as String),
      timezone: json['timezone'] as String?,
      duration: json['duration'] as String?,
      meetingAgenda: json['meeting_agenda'] as String?,
      isAutoId: json['is_auto_id'] as String?,
      autoGeneratedId: json['auto_generated_id'] as String?,
      isAllMute: json['is_all_mute'] as int?,
      allowToJoin: int.tryParse(json['allow_to_join'].toString()),
      recordToLocal: json['record_to_local'] as int?,
      allowCountry: int.tryParse(json['allow_country'].toString()),
      country: json['country'] as String?,
      roomCategory: json['room_category'] as String?,
      userId: json['user_id'] as int?,
      endDate: json['end_date'] == null ? null : DateTime.parse(json['end_date'] as String),
      isEventReminder: int.tryParse(json['is_event_reminder'].toString()),
      reminderTime: json['reminder_time'].toString() ?? "",
      isAutoRecording: json['is_auto_recording'] as int?,
      exitUrl: json['exit_url'] as String?,
      cancelReason: json['cancel_reason'],
      isActive: json['is_active'] as int?,
      isStarted: json['is_started'] as int?,
      username: json['username'] as String?,
      userEmail: json['user_email'] as String?,
      userPlan: json['userPlan'] as String?,
      updatedOn: json['updated_on'] == null ? null : DateTime.parse(json['updated_on'] as String),
      isMeetingLocked: json['is_meeting_locked'] as bool?,
      hostKey: json['host_key'] as String?,
      participantKey: json['participant_key'] as String?,
      guestKey: json['guest_key'] as String?,
      createdOn: json['created_on'] == null ? null : DateTime.parse(json['created_on'] as String),
      id: json['_id'] as String?,
      participantCustom: json['participant_custom'] as String?,
      hostCustom: json['host_custom'] as String?,
      guestCustom: json['guest_custom'] as String?,
      emails: json['emails'] as List<dynamic>?,
      contacts: json['contacts'] as List<dynamic>?,
      groups: json['groups'] as List<dynamic>?,
      isStartedBefore: json['isStartedBefore'] as bool?,
      isEventExpired: json['isEventExpired'] as bool?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$MeetingDataToJson(MeetingData instance) => <String, dynamic>{
      'meeting_name': instance.meetingName,
      'meeting_password': instance.meetingPassword,
      'room_type': instance.roomType,
      'meeting_type': instance.meetingType,
      'meeting_date': instance.meetingDate?.toIso8601String(),
      'timezone': instance.timezone,
      'duration': instance.duration,
      'meeting_agenda': instance.meetingAgenda,
      'is_auto_id': instance.isAutoId,
      'auto_generated_id': instance.autoGeneratedId,
      'is_all_mute': instance.isAllMute,
      'allow_to_join': instance.allowToJoin,
      'record_to_local': instance.recordToLocal,
      'allow_country': instance.allowCountry,
      'country': instance.country,
      'room_category': instance.roomCategory,
      'user_id': instance.userId,
      'end_date': instance.endDate?.toIso8601String(),
      'is_event_reminder': instance.isEventReminder,
      'reminder_time': instance.reminderTime,
      'is_auto_recording': instance.isAutoRecording,
      'exit_url': instance.exitUrl,
      'cancel_reason': instance.cancelReason,
      'is_active': instance.isActive,
      'is_started': instance.isStarted,
      'username': instance.username,
      'user_email': instance.userEmail,
      'userPlan': instance.userPlan,
      'updated_on': instance.updatedOn?.toIso8601String(),
      'is_meeting_locked': instance.isMeetingLocked,
      'host_key': instance.hostKey,
      'participant_key': instance.participantKey,
      'guest_key': instance.guestKey,
      'created_on': instance.createdOn?.toIso8601String(),
      '_id': instance.id,
      'participant_custom': instance.participantCustom,
      'host_custom': instance.hostCustom,
      'guest_custom': instance.guestCustom,
      'emails': instance.emails,
      'contacts': instance.contacts,
      'groups': instance.groups,
      'isStartedBefore': instance.isStartedBefore,
      'isEventExpired': instance.isEventExpired,
      'token': instance.token,
    };
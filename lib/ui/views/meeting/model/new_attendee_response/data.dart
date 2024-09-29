import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class AttendeeData extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'participant_name')
  final String? participantName;
  @JsonKey(name: 'participant_email')
  final String? participantEmail;
  @JsonKey(name: 'meeting_id')
  final String? meetingId;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'meeting_name')
  final String? meetingName;
  @JsonKey(name: 'country')
  final String? country;
  @JsonKey(name: 'join_time')
  final DateTime? joinTime;
  @JsonKey(name: 'leave_time')
  final dynamic leaveTime;
  @JsonKey(name: 'role_type')
  final String? roleType;
  @JsonKey(name: 'limitReached')
  final bool? limitReached;
  final bool? activeHost;
  @JsonKey(name: 'speakerLimitReached')
  final bool? speakerLimitReached;
  final bool? guestLimitReached;
  final int? loop;
  @JsonKey(name: 'is_meeting_locked')
  final bool? isMeetingLocked;
  @JsonKey(name: 'is_blocked')
  final int? isBlocked;

  const AttendeeData({
    this.id,
    this.participantName,
    this.participantEmail,
    this.meetingId,
    this.userId,
    this.meetingName,
    this.country,
    this.joinTime,
    this.leaveTime,
    this.roleType,
    this.limitReached,
    this.speakerLimitReached,
    this.guestLimitReached,
    this.loop,
    this.isMeetingLocked,
    this.isBlocked,
    this.activeHost,
  });

  AttendeeData copyWith({
    String? id,
    String? participantName,
    String? participantEmail,
    String? meetingId,
    int? userId,
    String? meetingName,
    String? country,
    DateTime? joinTime,
    dynamic leaveTime,
    String? roleType,
    bool? limitReached,
    bool? speakerLimitReached,
    bool? guestLimitReached,
    int? loop,
    bool? isMeetingLocked,
    int? isBlocked,
    bool? activeHost,
  }) {
    return AttendeeData(
      id: id ?? this.id,
      participantName: participantName ?? this.participantName,
      participantEmail: participantEmail ?? this.participantEmail,
      meetingId: meetingId ?? this.meetingId,
      userId: userId ?? this.userId,
      meetingName: meetingName ?? this.meetingName,
      country: country ?? this.country,
      joinTime: joinTime ?? this.joinTime,
      leaveTime: leaveTime ?? this.leaveTime,
      roleType: roleType ?? this.roleType,
      limitReached: limitReached ?? this.limitReached,
      speakerLimitReached: speakerLimitReached ?? this.speakerLimitReached,
      guestLimitReached: guestLimitReached ?? this.guestLimitReached,
      loop: loop ?? this.loop,
      isMeetingLocked: isMeetingLocked ?? this.isMeetingLocked,
      isBlocked: isBlocked ?? this.isBlocked,
      activeHost: activeHost ?? this.activeHost,
    );
  }
    
  
  factory AttendeeData.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      participantName,
      participantEmail,
      meetingId,
      userId,
      meetingName,
      country,
      joinTime,
      leaveTime,
      roleType,
      limitReached,
      speakerLimitReached,
      guestLimitReached,
      loop,
      isMeetingLocked,
      activeHost,
    ];
  }

  bool get isTempBlocked => isBlocked == 2;
}

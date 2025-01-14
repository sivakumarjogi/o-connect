class MeetingDetailsModel {
  String? id;
  String? meetingName;
  String? meetingPassword;
  String? roomType;
  String? meetingType;
  DateTime? meetingDate;
  String? timezone;
  String? duration;
  String? meetingAgenda;
  String? isAutoId;
  String? autoGeneratedId;
  int? isAllMute;
  String? allowToJoin;
  int? recordToLocal;
  int? allowCountry;
  String? country;
  String? roomCategory;
  int? userId;
  DateTime? endDate;
  String? isEventReminder;
  String? reminderTime;
  int? isAutoRecording;
  String? exitUrl;
  dynamic cancelReason;
  int? isActive;
  int? isStarted;
  String? username;
  String? userEmail;
  String? userPlan;
  String? userProfilePic;
  dynamic sessionId;
  DateTime? updatedOn;
  bool? isMeetingLocked;
  String? hostKey;
  String? participantKey;
  String? guestKey;
  DateTime? createdOn;
  String? guestUrl;
  String? hostUrl;
  String? participantUrl;
  List<InvitedDetail>? invitedDetails;

  MeetingDetailsModel({
    this.id,
    this.meetingName,
    this.meetingPassword,
    this.roomType,
    this.meetingType,
    this.meetingDate,
    this.timezone,
    this.duration,
    this.meetingAgenda,
    this.isAutoId,
    this.autoGeneratedId,
    this.isAllMute,
    this.allowToJoin,
    this.recordToLocal,
    this.allowCountry,
    this.country,
    this.roomCategory,
    this.userId,
    this.endDate,
    this.isEventReminder,
    this.reminderTime,
    this.isAutoRecording,
    this.exitUrl,
    this.cancelReason,
    this.isActive,
    this.isStarted,
    this.username,
    this.userEmail,
    this.userPlan,
    this.userProfilePic,
    this.sessionId,
    this.updatedOn,
    this.isMeetingLocked,
    this.hostKey,
    this.participantKey,
    this.guestKey,
    this.createdOn,
    this.guestUrl,
    this.hostUrl,
    this.participantUrl,
    this.invitedDetails,
  });

  MeetingDetailsModel copyWith({
    String? id,
    String? meetingName,
    String? meetingPassword,
    String? roomType,
    String? meetingType,
    DateTime? meetingDate,
    String? timezone,
    String? duration,
    String? meetingAgenda,
    String? isAutoId,
    String? autoGeneratedId,
    int? isAllMute,
    String? allowToJoin,
    int? recordToLocal,
    int? allowCountry,
    String? country,
    String? roomCategory,
    int? userId,
    DateTime? endDate,
    String? isEventReminder,
    String? reminderTime,
    int? isAutoRecording,
    String? exitUrl,
    dynamic cancelReason,
    int? isActive,
    int? isStarted,
    String? username,
    String? userEmail,
    String? userPlan,
    String? userProfilePic,
    dynamic sessionId,
    DateTime? updatedOn,
    bool? isMeetingLocked,
    String? hostKey,
    String? participantKey,
    String? guestKey,
    DateTime? createdOn,
    String? guestUrl,
    String? hostUrl,
    String? participantUrl,
    List<InvitedDetail>? invitedDetails,
  }) =>
      MeetingDetailsModel(
        id: id ?? this.id,
        meetingName: meetingName ?? this.meetingName,
        meetingPassword: meetingPassword ?? this.meetingPassword,
        roomType: roomType ?? this.roomType,
        meetingType: meetingType ?? this.meetingType,
        meetingDate: meetingDate ?? this.meetingDate,
        timezone: timezone ?? this.timezone,
        duration: duration ?? this.duration,
        meetingAgenda: meetingAgenda ?? this.meetingAgenda,
        isAutoId: isAutoId ?? this.isAutoId,
        autoGeneratedId: autoGeneratedId ?? this.autoGeneratedId,
        isAllMute: isAllMute ?? this.isAllMute,
        allowToJoin: allowToJoin ?? this.allowToJoin,
        recordToLocal: recordToLocal ?? this.recordToLocal,
        allowCountry: allowCountry ?? this.allowCountry,
        country: country ?? this.country,
        roomCategory: roomCategory ?? this.roomCategory,
        userId: userId ?? this.userId,
        endDate: endDate ?? this.endDate,
        isEventReminder: isEventReminder ?? this.isEventReminder,
        reminderTime: reminderTime ?? this.reminderTime,
        isAutoRecording: isAutoRecording ?? this.isAutoRecording,
        exitUrl: exitUrl ?? this.exitUrl,
        cancelReason: cancelReason ?? this.cancelReason,
        isActive: isActive ?? this.isActive,
        isStarted: isStarted ?? this.isStarted,
        username: username ?? this.username,
        userEmail: userEmail ?? this.userEmail,
        userPlan: userPlan ?? this.userPlan,
        userProfilePic: userProfilePic ?? this.userProfilePic,
        sessionId: sessionId ?? this.sessionId,
        updatedOn: updatedOn ?? this.updatedOn,
        isMeetingLocked: isMeetingLocked ?? this.isMeetingLocked,
        hostKey: hostKey ?? this.hostKey,
        participantKey: participantKey ?? this.participantKey,
        guestKey: guestKey ?? this.guestKey,
        createdOn: createdOn ?? this.createdOn,
        guestUrl: guestUrl ?? this.guestUrl,
        hostUrl: hostUrl ?? this.hostUrl,
        participantUrl: participantUrl ?? this.participantUrl,
        invitedDetails: invitedDetails ?? this.invitedDetails,
      );

  factory MeetingDetailsModel.fromJson(Map<String, dynamic> json) => MeetingDetailsModel(
        id: json["_id"],
        meetingName: json["meeting_name"],
        meetingPassword: json["meeting_password"],
        roomType: json["room_type"],
        meetingType: json["meeting_type"],
        meetingDate: json["meeting_date"] == null ? null : DateTime.parse(json["meeting_date"]),
        timezone: json["timezone"],
        duration: json["duration"],
        meetingAgenda: json["meeting_agenda"],
        isAutoId: json["is_auto_id"],
        autoGeneratedId: json["auto_generated_id"],
        isAllMute: json["is_all_mute"],
        allowToJoin: json["allow_to_join"].toString(),
        recordToLocal: json["record_to_local"],
        allowCountry: json["allow_country"],
        country: json["country"],
        roomCategory: json["room_category"],
        userId: json["user_id"],
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        isEventReminder: json["is_event_reminder"].toString(),
        reminderTime: json["reminder_time"].toString(),
        isAutoRecording: json["is_auto_recording"],
        exitUrl: json["exit_url"],
        cancelReason: json["cancel_reason"],
        isActive: json["is_active"],
        isStarted: json["is_started"],
        username: json["username"],
        userEmail: json["user_email"],
        userPlan: json["userPlan"],
        userProfilePic: json["user_profilePic"],
        sessionId: json["session_id"],
        updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
        isMeetingLocked: json["is_meeting_locked"],
        hostKey: json["host_key"],
        participantKey: json["participant_key"],
        guestKey: json["guest_key"],
        createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
        guestUrl: json["guest_url"],
        hostUrl: json["host_url"],
        participantUrl: json["participant_url"],
        invitedDetails: json["InvitedDetails"] == null ? [] : List<InvitedDetail>.from(json["InvitedDetails"]!.map((x) => InvitedDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "meeting_name": meetingName,
        "meeting_password": meetingPassword,
        "room_type": roomType,
        "meeting_type": meetingType,
        "meeting_date": meetingDate?.toIso8601String(),
        "timezone": timezone,
        "duration": duration,
        "meeting_agenda": meetingAgenda,
        "is_auto_id": isAutoId,
        "auto_generated_id": autoGeneratedId,
        "is_all_mute": isAllMute,
        "allow_to_join": allowToJoin,
        "record_to_local": recordToLocal,
        "allow_country": allowCountry,
        "country": country,
        "room_category": roomCategory,
        "user_id": userId,
        "end_date": endDate?.toIso8601String(),
        "is_event_reminder": isEventReminder,
        "reminder_time": reminderTime,
        "is_auto_recording": isAutoRecording,
        "exit_url": exitUrl,
        "cancel_reason": cancelReason,
        "is_active": isActive,
        "is_started": isStarted,
        "username": username,
        "user_email": userEmail,
        "userPlan": userPlan,
        "user_profilePic": userProfilePic,
        "session_id": sessionId,
        "updated_on": updatedOn?.toIso8601String(),
        "is_meeting_locked": isMeetingLocked,
        "host_key": hostKey,
        "participant_key": participantKey,
        "guest_key": guestKey,
        "created_on": createdOn?.toIso8601String(),
        "guest_url": guestUrl,
        "host_url": hostUrl,
        "participant_url": participantUrl,
        "InvitedDetails": invitedDetails == null ? [] : List<dynamic>.from(invitedDetails!.map((x) => x.toJson())),
      };
}

class InvitedDetail {
  String? omailEmailId;
  String? email;
  int? contactId;
  String? name;
  int? contactFlag;
  int? roleId;
  String? profilePic;
  String? firstName;
  String? lastName;
  bool? isNotified;
  int? isInviteAccepted;

  InvitedDetail({
    this.omailEmailId,
    this.email,
    this.contactId,
    this.name,
    this.contactFlag,
    this.roleId,
    this.profilePic,
    this.firstName,
    this.lastName,
    this.isNotified,
    this.isInviteAccepted,
  });

  InvitedDetail copyWith({
    String? omailEmailId,
    String? email,
    int? contactId,
    String? name,
    int? contactFlag,
    int? roleId,
    String? profilePic,
    String? firstName,
    String? lastName,
    bool? isNotified,
    int? isInviteAccepted,
  }) =>
      InvitedDetail(
        omailEmailId: omailEmailId ?? this.omailEmailId,
        email: email ?? this.email,
        contactId: contactId ?? this.contactId,
        name: name ?? this.name,
        contactFlag: contactFlag ?? this.contactFlag,
        roleId: roleId ?? this.roleId,
        profilePic: profilePic ?? this.profilePic,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        isNotified: isNotified ?? this.isNotified,
        isInviteAccepted: isInviteAccepted ?? this.isInviteAccepted,
      );

  factory InvitedDetail.fromJson(Map<String, dynamic> json) => InvitedDetail(
        omailEmailId: json["omailEmailId"],
        email: json["email"],
        contactId: json["contact_id"],
        name: json["name"],
        contactFlag: json["contact_flag"],
        roleId: json["role_id"],
        profilePic: json["profile_pic"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        isNotified: json["is_notified"],
        isInviteAccepted: json["is_invite_accepted"],
      );

  Map<String, dynamic> toJson() => {
        "omailEmailId": omailEmailId,
        "email": email,
        "contact_id": contactId,
        "name": name,
        "contact_flag": contactFlag,
        "role_id": roleId,
        "profile_pic": profilePic,
        "firstName": firstName,
        "lastName": lastName,
        "is_notified": isNotified,
        "is_invite_accepted": isInviteAccepted,
      };
}

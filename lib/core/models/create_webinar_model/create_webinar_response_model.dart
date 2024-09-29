// To parse this JSON data, do
//
//     final createWebinarResponseModel = createWebinarResponseModelFromJson(jsonString);

import 'dart:convert';

CreateWebinarResponseModel createWebinarResponseModelFromJson(String str) => CreateWebinarResponseModel.fromJson(json.decode(str));

String createWebinarResponseModelToJson(CreateWebinarResponseModel data) => json.encode(data.toJson());

class CreateWebinarResponseModel {
  bool? status;
  CreateWebinarResponseData? data;

  CreateWebinarResponseModel({
    this.status,
    this.data,
  });

  factory CreateWebinarResponseModel.fromJson(Map<String, dynamic> json) => CreateWebinarResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : CreateWebinarResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class CreateWebinarResponseData {
  String? id;
  int? userId;
  String? meetingName;
  String? meetingAgenda;
  String? roomCategory;
  DateTime? meetingDate;
  DateTime? endDate;
  String? meetingPassword;
  String? timezone;
  String? roomType;
  String? meetingType;
  String? duration;
  String? autoGeneratedId;
  String? isAutoId;
  int? isAllMute;
  dynamic allowToJoin;
  int? recordToLocal;
  int? allowCountry;
  String? country;
  dynamic isEventReminder;
  dynamic reminderTime;
  dynamic cancelReason;
  String? exitUrl;
  String? hostUrl;
  String? participantUrl;
  dynamic guestUrl;
  String? hostKey;
  String? participantKey;
  String? guestKey;
  dynamic sessionId;
  int? isAutoRecording;
  int? isActive;
  int? isStarted;
  String? username;
  String? userEmail;
  String? userPlan;
  bool? isMeetingLocked;
  DateTime? updatedOn;
  DateTime? createdOn;
  String? type;
  String? password;
  String? date;
  String? time;
  List<dynamic>? emails;
  List<Contact>? contacts;
  List<dynamic>? groups;

  CreateWebinarResponseData({
    this.id,
    this.userId,
    this.meetingName,
    this.meetingAgenda,
    this.roomCategory,
    this.meetingDate,
    this.endDate,
    this.meetingPassword,
    this.timezone,
    this.roomType,
    this.meetingType,
    this.duration,
    this.autoGeneratedId,
    this.isAutoId,
    this.isAllMute,
    this.allowToJoin,
    this.recordToLocal,
    this.allowCountry,
    this.country,
    this.isEventReminder,
    this.reminderTime,
    this.cancelReason,
    this.exitUrl,
    this.hostUrl,
    this.participantUrl,
    this.guestUrl,
    this.hostKey,
    this.participantKey,
    this.guestKey,
    this.sessionId,
    this.isAutoRecording,
    this.isActive,
    this.isStarted,
    this.username,
    this.userEmail,
    this.userPlan,
    this.isMeetingLocked,
    this.updatedOn,
    this.createdOn,
    this.type,
    this.password,
    this.date,
    this.time,
    this.emails,
    this.contacts,
    this.groups,
  });

  factory CreateWebinarResponseData.fromJson(Map<String, dynamic> json) => CreateWebinarResponseData(
        id: json["_id"],
        userId: json["user_id"],
        meetingName: json["meeting_name"],
        meetingAgenda: json["meeting_agenda"],
        roomCategory: json["room_category"],
        meetingDate: json["meeting_date"] == null ? null : DateTime.parse(json["meeting_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        meetingPassword: json["meeting_password"],
        timezone: json["timezone"],
        roomType: json["room_type"],
        meetingType: json["meeting_type"],
        duration: json["duration"],
        autoGeneratedId: json["auto_generated_id"],
        isAutoId: json["is_auto_id"],
        isAllMute: json["is_all_mute"],
        allowToJoin: json["allow_to_join"],
        recordToLocal: json["record_to_local"],
        allowCountry: json["allow_country"],
        country: json["country"],
        isEventReminder: json["is_event_reminder"],
        reminderTime: json["reminder_time"],
        cancelReason: json["cancel_reason"],
        exitUrl: json["exit_url"],
        hostUrl: json["host_url"],
        participantUrl: json["participant_url"],
        guestUrl: json["guest_url"],
        hostKey: json["host_key"],
        participantKey: json["participant_key"],
        guestKey: json["guest_key"],
        sessionId: json["session_id"],
        isAutoRecording: json["is_auto_recording"],
        isActive: json["is_active"],
        isStarted: json["is_started"],
        username: json["username"],
        userEmail: json["user_email"],
        userPlan: json["userPlan"],
        isMeetingLocked: json["is_meeting_locked"],
        updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
        createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
        type: json["type"],
        password: json["password"],
        date: json["date"],
        time: json["time"],
        emails: json["emails"] == null ? [] : List<dynamic>.from(json["emails"]!.map((x) => x)),
        contacts: json["contacts"] == null ? [] : List<Contact>.from(json["contacts"]!.map((x) => Contact.fromJson(x))),
        groups: json["groups"] == null ? [] : List<dynamic>.from(json["groups"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "meeting_name": meetingName,
        "meeting_agenda": meetingAgenda,
        "room_category": roomCategory,
        "meeting_date": meetingDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "meeting_password": meetingPassword,
        "timezone": timezone,
        "room_type": roomType,
        "meeting_type": meetingType,
        "duration": duration,
        "auto_generated_id": autoGeneratedId,
        "is_auto_id": isAutoId,
        "is_all_mute": isAllMute,
        "allow_to_join": allowToJoin,
        "record_to_local": recordToLocal,
        "allow_country": allowCountry,
        "country": country,
        "is_event_reminder": isEventReminder,
        "reminder_time": reminderTime,
        "cancel_reason": cancelReason,
        "exit_url": exitUrl,
        "host_url": hostUrl,
        "participant_url": participantUrl,
        "guest_url": guestUrl,
        "host_key": hostKey,
        "participant_key": participantKey,
        "guest_key": guestKey,
        "session_id": sessionId,
        "is_auto_recording": isAutoRecording,
        "is_active": isActive,
        "is_started": isStarted,
        "username": username,
        "user_email": userEmail,
        "userPlan": userPlan,
        "is_meeting_locked": isMeetingLocked,
        "updated_on": updatedOn?.toIso8601String(),
        "created_on": createdOn?.toIso8601String(),
        "type": type,
        "password": password,
        "date": date,
        "time": time,
        "emails": emails == null ? [] : List<dynamic>.from(emails!.map((x) => x)),
        "contacts": contacts == null ? [] : List<dynamic>.from(contacts!.map((x) => x.toJson())),
        "groups": groups == null ? [] : List<dynamic>.from(groups!.map((x) => x)),
      };
}

class Contact {
  int? contactFlag;
  int? contactId;
  String? email;
  String? name;
  int? roleId;
  bool? isNotified;

  Contact({
    this.contactFlag,
    this.contactId,
    this.email,
    this.name,
    this.roleId,
    this.isNotified,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        contactFlag: json["contact_flag"],
        contactId: json["contact_id"],
        email: json["email"],
        name: json["name"],
        roleId: json["role_id"],
        isNotified: json["is_notified"],
      );

  Map<String, dynamic> toJson() => {
        "contact_flag": contactFlag,
        "contact_id": contactId,
        "email": email,
        "name": name,
        "role_id": roleId,
        "is_notified": isNotified,
      };
}

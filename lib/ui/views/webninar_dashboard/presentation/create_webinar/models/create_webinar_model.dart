import 'dart:convert';

CreateWebinarModel createWebinarModelFromJson(String str) => CreateWebinarModel.fromJson(json.decode(str));

String createWebinarModelToJson(CreateWebinarModel data) => json.encode(data.toJson());

class CreateWebinarModel {
  String? name;
  String? comments;
  List<CreateWebinarModelEmail>? emails;
  List<dynamic>? contacts;
  List<dynamic>? groups;
  String? roomType;
  String? roomCategory;
  String? guestKey;
  String? meetingDate;
  String? meetingType;
  String? getDate;
  CreateWebinarModelDuration? getTime;
  CreateWebinarModelDuration? duration;
  String? timezone;
  String? isAutoId;
  String? autoGeneratedId;
  String? password;
  String? allowToJoin;
  dynamic isEventReminder;
  String? reminderTime;
  String? recordToLocal;
  String? recordAuto;
  String? exitUrl;
  int? userId;
  String? meetingId;
  CreateWebinarModelUserInfo? userInfo;
  bool? meetingConflict;
  String? country;

  CreateWebinarModel({
    this.name,
    this.comments,
    this.emails,
    this.contacts,
    this.groups,
    this.roomType,
    this.roomCategory,
    this.guestKey,
    this.meetingDate,
    this.meetingType,
    this.getDate,
    this.getTime,
    this.duration,
    this.timezone,
    this.isAutoId,
    this.autoGeneratedId,
    this.password,
    this.allowToJoin,
    this.isEventReminder,
    this.reminderTime,
    this.recordToLocal,
    this.recordAuto,
    this.exitUrl,
    this.userId,
    this.meetingId,
    this.userInfo,
    this.meetingConflict,
    this.country,
  });

  factory CreateWebinarModel.fromJson(Map<String, dynamic> json) => CreateWebinarModel(
        name: json["name"],
        comments: json["comments"],
        emails: json["emails"] == null ? [] : List<CreateWebinarModelEmail>.from(json["emails"]!.map((x) => CreateWebinarModelEmail.fromJson(x))),
        contacts: json["contacts"] == null ? [] : List<dynamic>.from(json["contacts"]!.map((x) => x)),
        groups: json["groups"] == null ? [] : List<dynamic>.from(json["groups"]!.map((x) => x)),
        roomType: json["room_type"],
        roomCategory: json["room_category"],
        guestKey: json["guestKey"],
        meetingDate: json["meeting_date"] /* == null ? null : DateTime.parse(json["meeting_date"]) */,
        meetingType: json["meeting_type"],
        getDate: json["getDate"],
        getTime: json["getTime"] == null ? null : CreateWebinarModelDuration.fromJson(json["getTime"]),
        duration: json["duration"] == null ? null : CreateWebinarModelDuration.fromJson(json["duration"]),
        timezone: json["timezone"],
        isAutoId: json["is_auto_id"],
        autoGeneratedId: json["auto_generated_id"],
        password: json["password"],
        allowToJoin: json["allow_to_join"],
        isEventReminder: json["is_event_reminder"],
        reminderTime: json["reminder_time"],
        recordToLocal: json["recordToLocal"],
        recordAuto: json["recordAuto"],
        exitUrl: json["exit_url"],
        userId: json["user_id"],
        userInfo: json["userInfo"] == null ? null : CreateWebinarModelUserInfo.fromJson(json["userInfo"]),
        meetingConflict: json["meeting_conflict"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "comments": comments,
        "emails": emails == null ? [] : List<dynamic>.from(emails!.map((x) => x.toJson())),
        "contacts": contacts == null ? [] : List<dynamic>.from(contacts!.map((x) => x)),
        "groups": groups == null ? [] : List<dynamic>.from(groups!.map((x) => x)),
        "room_type": roomType,
        "room_category": roomCategory,
        "guestKey": guestKey,
        "meeting_date": meetingDate /* ?.toIso8601String() */,
        "meeting_type": meetingType,
        "getDate": getDate,
        "getTime": getTime?.toJson(),
        "duration": duration?.toJson(),
        "timezone": timezone,
        "is_auto_id": isAutoId,
        "auto_generated_id": autoGeneratedId,
        "password": password,
        "allow_to_join": allowToJoin,
        "is_event_reminder": isEventReminder,
        "reminder_time": reminderTime,
        "recordToLocal": recordToLocal,
        "recordAuto": recordAuto,
        "exit_url": exitUrl,
        "user_id": userId,
        if (meetingId != null && meetingId!.isNotEmpty) "meeting_id": meetingId,
        "userInfo": userInfo?.toJson(),
        "meeting_conflict": meetingConflict,
        "country": country,
      };
}

class CreateWebinarModelDuration {
  int? hour;
  int? minute;

  CreateWebinarModelDuration({
    this.hour,
    this.minute,
  });

  factory CreateWebinarModelDuration.fromJson(Map<String, dynamic> json) => CreateWebinarModelDuration(
        hour: json["hour"],
        minute: json["minute"],
      );

  Map<String, dynamic> toJson() => {
        "hour": hour,
        "minute": minute,
      };
}

class CreateWebinarModelEmail {
  int? contactFlag;
  String? email;
  int? roleId;
  String? omailEmailId;
  int? contactId;
  String? name;
  String? type;

  CreateWebinarModelEmail({
    this.contactFlag,
    this.email,
    this.roleId,
    this.omailEmailId,
    this.contactId,
    this.name,
    this.type,
  });

  factory CreateWebinarModelEmail.fromJson(Map<String, dynamic> json) => CreateWebinarModelEmail(
        contactFlag: json["contact_flag"],
        email: json["email"],
        roleId: json["role_id"],
        omailEmailId: json["omailEmailId"],
        contactId: json["contact_id"],
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "contact_flag": contactFlag,
        "email": email,
        "role_id": roleId,
        "omailEmailId": omailEmailId,
        "contact_id": contactId,
        "name": name,
        "type": type,
      };
}

class CreateWebinarModelUserInfo {
  String? userName;
  String? userEmail;
  String? name;
  String? userType;
  String? profilePic;

  CreateWebinarModelUserInfo({
    this.userName,
    this.userEmail,
    this.name,
    this.userType,
    this.profilePic,
  });

  factory CreateWebinarModelUserInfo.fromJson(Map<String, dynamic> json) => CreateWebinarModelUserInfo(
        userName: json["userName"],
        userEmail: json["userEmail"],
        name: json["name"],
        userType: json["userType"],
        profilePic: json["profilePic"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "userEmail": userEmail,
        "name": name,
        if (userType != null && userType!.isNotEmpty) "userType": userType,
        "profilePic": profilePic,
      };
}
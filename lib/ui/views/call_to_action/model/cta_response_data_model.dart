// To parse this JSON data, do
//
//     final ctaResponseData = ctaResponseDataFromJson(jsonString);

import 'dart:convert';

CtaResponseDataModel ctaResponseDataFromJson(String str) => CtaResponseDataModel.fromJson(json.decode(str));

String ctaResponseDataToJson(CtaResponseDataModel data) => json.encode(data.toJson());

class CtaResponseDataModel {
  int? userId;
  String? meetingId;
  String? meetingName;
  DateTime? meetingDate;
  String? title;
  String? buttonUrl;
  String? buttonText;
  CtaResponseDataDisplayTime? displayTime;
  int? isActive;
  DateTime? createdOn;
  DateTime? updatedOn;
  String? id;
  String? headerBgColor;
  String? headerTextColor;
  String? buttonBgColor;
  String? buttonTextColor;
  int? ou;
  String? on;
  DateTime? addedTime;

  CtaResponseDataModel({
    this.userId,
    this.meetingId,
    this.meetingName,
    this.meetingDate,
    this.title,
    this.buttonUrl,
    this.buttonText,
    this.displayTime,
    this.isActive,
    this.createdOn,
    this.updatedOn,
    this.id,
    this.headerBgColor,
    this.headerTextColor,
    this.buttonBgColor,
    this.buttonTextColor,
    this.ou,
    this.on,
    this.addedTime,
  });

  factory CtaResponseDataModel.fromJson(Map<String, dynamic> json) => CtaResponseDataModel(
    userId: json["user_id"],
    meetingId: json["meeting_id"],
    meetingName: json["meeting_name"],
    meetingDate: json["meeting_date"] == null ? null : DateTime.parse(json["meeting_date"]),
    title: json["title"],
    buttonUrl: json["button_url"],
    buttonText: json["button_text"],
    displayTime: json["display_time"] == null ? null : CtaResponseDataDisplayTime.fromJson(json["display_time"]),
    isActive: json["is_active"],
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
    updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
    id: json["_id"],
    headerBgColor: json["headerBgColor"],
    headerTextColor: json["headerTextColor"],
    buttonBgColor: json["buttonBgColor"],
    buttonTextColor: json["buttonTextColor"],
    ou: json["ou"],
    on: json["on"],
    addedTime: json["addedTime"] == null ? null : DateTime.parse(json["addedTime"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "meeting_id": meetingId,
    "meeting_name": meetingName,
    "meeting_date": meetingDate?.toIso8601String(),
    "title": title,
    "button_url": buttonUrl,
    "button_text": buttonText,
    "display_time": displayTime?.toJson(),
    "is_active": isActive,
    "created_on": createdOn?.toIso8601String(),
    "updated_on": updatedOn?.toIso8601String(),
    "_id": id,
    "headerBgColor": headerBgColor,
    "headerTextColor": headerTextColor,
    "buttonBgColor": buttonBgColor,
    "buttonTextColor": buttonTextColor,
    "ou": ou,
    "on": on,
    "addedTime": addedTime?.toIso8601String(),
  };
}

class CtaResponseDataDisplayTime {
  String? minutes;
  String? seconds;

  CtaResponseDataDisplayTime({
    this.minutes,
    this.seconds,
  });

  factory CtaResponseDataDisplayTime.fromJson(Map<String, dynamic> json) => CtaResponseDataDisplayTime(
    minutes: json["minutes"],
    seconds: json["seconds"],
  );

  Map<String, dynamic> toJson() => {
    "minutes": minutes,
    "seconds": seconds,
  };
}

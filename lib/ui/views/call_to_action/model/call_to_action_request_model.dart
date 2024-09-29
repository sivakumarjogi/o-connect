// To parse this JSON data, do
//
//     final callToActionRequestModel = callToActionRequestModelFromJson(jsonString);

import 'dart:convert';

CallToActionRequestModel callToActionRequestModelFromJson(String str) => CallToActionRequestModel.fromJson(json.decode(str));

String callToActionRequestModelToJson(CallToActionRequestModel data) => json.encode(data.toJson());

class CallToActionRequestModel {
  int? userId;
  String? meetingId;
  String? meetingName;
  String? meetingDate;
  String? title;
  String? buttonUrl;
  String? buttonTxt;
  DisplayTime? displayTime;

  CallToActionRequestModel({
    this.userId,
    this.meetingId,
    this.meetingName,
    this.meetingDate,
    this.title,
    this.buttonUrl,
    this.buttonTxt,
    this.displayTime,
  });

  factory CallToActionRequestModel.fromJson(Map<String, dynamic> json) => CallToActionRequestModel(
        userId: json["user_id"],
        meetingId: json["meeting_id"],
        meetingName: json["meeting_name"],
        meetingDate: json["meeting_date"],
        title: json["title"],
        buttonUrl: json["button_url"],
        buttonTxt: json["button_txt"],
        displayTime: json["display_time"] == null ? null : DisplayTime.fromJson(json["display_time"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "meeting_id": meetingId,
        "meeting_name": meetingName,
        "meeting_date": meetingDate,
        "title": title,
        "button_url": buttonUrl,
        "button_txt": buttonTxt,
        "display_time": displayTime?.toJson(),
      };
}

class DisplayTime {
  String? minutes;
  String? seconds;

  DisplayTime({
    this.minutes,
    this.seconds,
  });

  factory DisplayTime.fromJson(Map<String, dynamic> json) => DisplayTime(
        minutes: json["minutes"],
        seconds: json["seconds"],
      );

  Map<String, dynamic> toJson() => {
        "minutes": minutes,
        "seconds": seconds,
      };
}

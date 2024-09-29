// To parse this JSON data, do
//
//     final callToActionResponseModel = callToActionResponseModelFromJson(jsonString);

import 'dart:convert';

CallToActionResponseModel callToActionResponseModelFromJson(String str) => CallToActionResponseModel.fromJson(json.decode(str));

String callToActionResponseModelToJson(CallToActionResponseModel data) => json.encode(data.toJson());

class CallToActionResponseModel {
  bool? status;
  CallToActionResponseModelData? data;

  CallToActionResponseModel({
    this.status,
    this.data,
  });

  factory CallToActionResponseModel.fromJson(Map<String, dynamic> json) => CallToActionResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : CallToActionResponseModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class CallToActionResponseModelData {
  int? userId;
  String? meetingId;
  String? meetingName;
  DateTime? meetingDate;
  String? title;
  String? buttonUrl;
  String? buttonText;
  CallToActionResponseModelDisplayTime? displayTime;
  int? isActive;
  DateTime? createdOn;
  DateTime? updatedOn;
  String? id;

  CallToActionResponseModelData({
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
  });

  factory CallToActionResponseModelData.fromJson(Map<String, dynamic> json) => CallToActionResponseModelData(
        userId: json["user_id"],
        meetingId: json["meeting_id"],
        meetingName: json["meeting_name"],
        meetingDate: json["meeting_date"] == null ? null : DateTime.parse(json["meeting_date"]),
        title: json["title"],
        buttonUrl: json["button_url"],
        buttonText: json["button_text"],
        displayTime: json["display_time"] == null ? null : CallToActionResponseModelDisplayTime.fromJson(json["display_time"]),
        isActive: json["is_active"],
        createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
        updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
        id: json["_id"],
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
      };
}

class CallToActionResponseModelDisplayTime {
  String? minutes;
  String? seconds;

  CallToActionResponseModelDisplayTime({
    this.minutes,
    this.seconds,
  });

  factory CallToActionResponseModelDisplayTime.fromJson(Map<String, dynamic> json) => CallToActionResponseModelDisplayTime(
        minutes: json["minutes"],
        seconds: json["seconds"],
      );

  Map<String, dynamic> toJson() => {
        "minutes": minutes,
        "seconds": seconds,
      };
}

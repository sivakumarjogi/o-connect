// To parse this JSON data, do
//
//     final allTemplatesModel = allTemplatesModelFromJson(jsonString);

import 'dart:convert';

AllTemplatesModel allTemplatesModelFromJson(String str) => AllTemplatesModel.fromJson(json.decode(str));

String allTemplatesModelToJson(AllTemplatesModel data) => json.encode(data.toJson());

class AllTemplatesModel {
  bool? status;
  List<dynamic>? data;

  AllTemplatesModel({
    this.status,
    this.data,
  });

  factory AllTemplatesModel.fromJson(Map<String, dynamic> json) => AllTemplatesModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
  };
}

class DatumClass {
  String? id;
  String? templateName;
  String? meetingId;
  int? userId;
  String? meetingType;
  String? meetingName;
  dynamic meetingAgenda;
  int? status;
  DateTime? updatedOn;
  DateTime? createdOn;

  DatumClass({
    this.id,
    this.templateName,
    this.meetingId,
    this.userId,
    this.meetingType,
    this.meetingName,
    this.meetingAgenda,
    this.status,
    this.updatedOn,
    this.createdOn,
  });

  factory DatumClass.fromJson(Map<String, dynamic> json) => DatumClass(
    id: json["_id"],
    templateName: json["template_name"],
    meetingId: json["meeting_id"],
    userId: json["user_id"],
    meetingType: json["meeting_type"],
    meetingName: json["meeting_name"],
    meetingAgenda: json["meeting_agenda"],
    status: json["status"],
    updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "template_name": templateName,
    "meeting_id": meetingId,
    "user_id": userId,
    "meeting_type": meetingType,
    "meeting_name": meetingName,
    "meeting_agenda": meetingAgenda,
    "status": status,
    "updated_on": updatedOn?.toIso8601String(),
    "created_on": createdOn?.toIso8601String(),
  };
}

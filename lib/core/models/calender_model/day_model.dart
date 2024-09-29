// import 'package:json_annotation/json_annotation.dart';
//
// part 'day_model.g.dart';
//
// @JsonSerializable()
// class CalenderDayModel {
//   String emailId;
//   DateTime fromDate;
//   DateTime toDate;
//   String status;
//   int pageNo;
//   dynamic pageSize;
//   List<Event> events;
//   int totalEvents;
//   int totalEventsFromOmail;
//   int totalEventsFromOnet;
//   int totalEventsFromOconnect;
//
//   CalenderDayModel({
//     required this.emailId,
//     required this.fromDate,
//     required this.toDate,
//     required this.status,
//     required this.pageNo,
//     this.pageSize,
//     required this.events,
//     required this.totalEvents,
//     required this.totalEventsFromOmail,
//     required this.totalEventsFromOnet,
//     required this.totalEventsFromOconnect,
//   });
//
//   factory CalenderDayModel.fromJson(Map<String, dynamic> json) => _$CalenderDayModelFromJson(json);
//
//
//   Map<String, dynamic> toJson() => _$CalenderDayModelToJson(this);
//
// }
// @JsonSerializable()
// class Event {
//   String id;
//   String name;
//   String description;
//   String image;
//   String type;
//   DateTime startTime;
//   DateTime endTime;
//   int productId;
//   String productName;
//   String status;
//
//   Event({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.image,
//     required this.type,
//     required this.startTime,
//     required this.endTime,
//     required this.productId,
//     required this.productName,
//     required this.status,
//   });
//
//   factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
//
//   Map<String, dynamic> toJson() => _$EventToJson(this);
// }

// To parse this JSON data, do
//
//     final calenderDayModel = calenderDayModelFromJson(jsonString);

import 'dart:convert';

CalenderDayModel calenderDayModelFromJson(String str) => CalenderDayModel.fromJson(json.decode(str));

String calenderDayModelToJson(CalenderDayModel data) => json.encode(data.toJson());

class CalenderDayModel {
  String? emailId;
  DateTime? fromDate;
  DateTime? toDate;
  String? status;
  dynamic pageNo;
  dynamic pageSize;
  List<Event>? events;
  int? totalEvents;
  int? totalEventsFromOmail;
  int? totalEventsFromOnet;
  int? totalEventsFromOconnect;

  CalenderDayModel({
     this.emailId,
     this.fromDate,
     this.toDate,
     this.status,
     this.pageNo,
     this.pageSize,
     this.events,
     this.totalEvents,
     this.totalEventsFromOmail,
     this.totalEventsFromOnet,
     this.totalEventsFromOconnect,
  });

   CalenderDayModel.fromJson(Map<String, dynamic> json) {
    emailId=
    json["emailId"];

    fromDate = DateTime.parse(json["fromDate"]);
    toDate = DateTime.parse(json["toDate"]);
    status = json["status"];
    pageNo = json["pageNo"];
    pageSize = json["pageSize"];
    events = List<Event>.from(json["events"].map((x) => Event.fromJson(x)));
    events!.sort((a, b) => b.startTime.compareTo(a.startTime));
    events!.removeWhere((event) => event.status == "NA");
    totalEvents = json["totalEvents"];
    totalEventsFromOmail = json["totalEventsFromOmail"];
    totalEventsFromOnet = json["totalEventsFromOnet"];
    totalEventsFromOconnect = json["totalEventsFromOconnect"];
  }

  Map<String, dynamic> toJson() => {
        "emailId": emailId,
        "fromDate": fromDate!.toIso8601String(),
        "toDate": toDate!.toIso8601String(),
        "status": status,
        "pageNo": pageNo,
        "pageSize": pageSize,
        "events": List<dynamic>.from(events!.map((x) => x.toJson())),



        "totalEvents": totalEvents,
        "totalEventsFromOmail": totalEventsFromOmail,
        "totalEventsFromOnet": totalEventsFromOnet,
        "totalEventsFromOconnect": totalEventsFromOconnect,
      };
}

class Event {
  String id;
  String name;
  String description;
  String image;
  String type;
  DateTime startTime;
  DateTime endTime;
  int productId;
  String productName;
  String status;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.productId,
    required this.productName,
    required this.status,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"] ?? '',
        type: json["type"]!,
        startTime: DateTime.parse(json["startDateTime"]).toLocal(),
        endTime: DateTime.parse(json["endDateTime"]).toLocal(),
        productId: json["productId"] ?? 0,
        productName: json["productName"] ?? 0,
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": image,
        "type": type,
        "startDateTime": startTime.toIso8601String(),
        "endDateTime": endTime.toIso8601String(),
        "productId": productId,
        "productName": productName,
        "status": status,
      };
}

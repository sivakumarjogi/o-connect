// To parse this JSON data, do
//
//     final acceptMeetingDetailsModel = acceptMeetingDetailsModelFromJson(jsonString);

import 'dart:convert';

AcceptMeetingDetailsModel acceptMeetingDetailsModelFromJson(String str) => AcceptMeetingDetailsModel.fromJson(json.decode(str));

String acceptMeetingDetailsModelToJson(AcceptMeetingDetailsModel data) => json.encode(data.toJson());

class AcceptMeetingDetailsModel {
    bool? status;
    String? message;

    AcceptMeetingDetailsModel({
        this.status,
        this.message,
    });

    AcceptMeetingDetailsModel copyWith({
        bool? status,
        String? message,
    }) => 
        AcceptMeetingDetailsModel(
            status: status ?? this.status,
            message: message ?? this.message,
        );

    factory AcceptMeetingDetailsModel.fromJson(Map<String, dynamic> json) => AcceptMeetingDetailsModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}

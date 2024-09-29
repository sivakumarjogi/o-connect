// To parse this JSON data, do
//
//     final getMeetingsInfoModel = getMeetingsInfoModelFromJson(jsonString);

import 'dart:convert';

GetMeetingsInfoModel getMeetingsInfoModelFromJson(String str) => GetMeetingsInfoModel.fromJson(json.decode(str));

String getMeetingsInfoModelToJson(GetMeetingsInfoModel data) => json.encode(data.toJson());

class GetMeetingsInfoModel {
    int? status;
    List<MeetingsCount>? meetingsCount;

    GetMeetingsInfoModel({
        this.status,
        this.meetingsCount,
    });

    GetMeetingsInfoModel copyWith({
        int? status,
        List<MeetingsCount>? meetingsCount,
    }) => 
        GetMeetingsInfoModel(
            status: status ?? this.status,
            meetingsCount: meetingsCount ?? this.meetingsCount,
        );

    factory GetMeetingsInfoModel.fromJson(Map<String, dynamic> json) => GetMeetingsInfoModel(
        status: json["status"],
        meetingsCount: json["meetingsCount"] == null ? [] : List<MeetingsCount>.from(json["meetingsCount"]!.map((x) => MeetingsCount.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "meetingsCount": meetingsCount == null ? [] : List<dynamic>.from(meetingsCount!.map((x) => x.toJson())),
    };
}

class MeetingsCount {
    int? createdMeetingCount;
    int? attendedMeetingCount;
    int? transferredMeetingCount;
    int? cancelledMeetingCount;
    int? invitedMeetingsCount;
    int? totalCount;

    MeetingsCount({
        this.createdMeetingCount,
        this.attendedMeetingCount,
        this.transferredMeetingCount,
        this.cancelledMeetingCount,
        this.invitedMeetingsCount,
        this.totalCount,
    });

    MeetingsCount copyWith({
        int? createdMeetingCount,
        int? attendedMeetingCount,
        int? transferredMeetingCount,
        int? cancelledMeetingCount,
        int? invitedMeetingsCount,
        int? totalCount,
    }) => 
        MeetingsCount(
            createdMeetingCount: createdMeetingCount ?? this.createdMeetingCount,
            attendedMeetingCount: attendedMeetingCount ?? this.attendedMeetingCount,
            transferredMeetingCount: transferredMeetingCount ?? this.transferredMeetingCount,
            cancelledMeetingCount: cancelledMeetingCount ?? this.cancelledMeetingCount,
            invitedMeetingsCount: invitedMeetingsCount ?? this.invitedMeetingsCount,
            totalCount: totalCount ?? this.totalCount,
        );

    factory MeetingsCount.fromJson(Map<String, dynamic> json) => MeetingsCount(
        createdMeetingCount: json["createdMeetingCount"],
        attendedMeetingCount: json["attendedMeetingCount"],
        transferredMeetingCount: json["transferredMeetingCount"],
        cancelledMeetingCount: json["cancelledMeetingCount"],
        invitedMeetingsCount: json["invitedMeetingsCount"],
        totalCount: json["totalCount"],
    );

    Map<String, dynamic> toJson() => {
        "createdMeetingCount": createdMeetingCount,
        "attendedMeetingCount": attendedMeetingCount,
        "transferredMeetingCount": transferredMeetingCount,
        "cancelledMeetingCount": cancelledMeetingCount,
        "invitedMeetingsCount": invitedMeetingsCount,
        "totalCount": totalCount,
    };
}

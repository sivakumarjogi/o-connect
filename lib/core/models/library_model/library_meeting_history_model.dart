// To parse this JSON data, do
//
//     final libraryMeetingHistoryModel = libraryMeetingHistoryModelFromJson(jsonString);

import 'dart:convert';

LibraryMeetingHistoryModel libraryMeetingHistoryModelFromJson(String str) => LibraryMeetingHistoryModel.fromJson(json.decode(str));

String libraryMeetingHistoryModelToJson(LibraryMeetingHistoryModel data) => json.encode(data.toJson());

class LibraryMeetingHistoryModel {
  bool? status;
  List<LibraryMeetingHistoryDatum>? libraryMeetingHistoryData;
  int? totalRecordsCount;
  String? currentRegion;

  LibraryMeetingHistoryModel({
    this.status,
    this.libraryMeetingHistoryData,
    this.totalRecordsCount,
    this.currentRegion,
  });

  LibraryMeetingHistoryModel copyWith({
    bool? status,
    List<LibraryMeetingHistoryDatum>? libraryMeetingHistoryData,
    int? totalRecordsCount,
    String? currentRegion,
  }) =>
      LibraryMeetingHistoryModel(
        status: status ?? this.status,
        libraryMeetingHistoryData: libraryMeetingHistoryData ?? this.libraryMeetingHistoryData,
        totalRecordsCount: totalRecordsCount ?? this.totalRecordsCount,
        currentRegion: currentRegion ?? this.currentRegion,
      );

  factory LibraryMeetingHistoryModel.fromJson(Map<String, dynamic> json) => LibraryMeetingHistoryModel(
        status: json["status"],
        libraryMeetingHistoryData: json["data"] == null ? [] : List<LibraryMeetingHistoryDatum>.from(json["data"]!.map((x) => LibraryMeetingHistoryDatum.fromJson(x))),
        totalRecordsCount: json["totalRecordsCount"],
        currentRegion: json["currentRegion"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": libraryMeetingHistoryData == null ? [] : List<dynamic>.from(libraryMeetingHistoryData!.map((x) => x.toJson())),
        "totalRecordsCount": totalRecordsCount,
        "currentRegion": currentRegion,
      };
}

class LibraryMeetingHistoryDatum {
  String? id;
  int? webinarVideo;
  int? allFeatures;
  int? whiteboard;
  int? presentation;
  int? folder;
  int? virtualBg;
  int? bgm;
  int? resounds;
  int? themes;
  int? recordings;
  int? banner;
  int? chat;
  int? survey;
  int? screenShot;
  int? callToAction;
  String? meetingName;
  DateTime? meetingDate;
  String? eventId;
  String? duration;
  int? createdBy;
  User? username;
  User? userEmail;
  dynamic userProfilePic;
  String? meetingType;
  int? count;

  LibraryMeetingHistoryDatum({
    this.id,
    this.webinarVideo,
    this.allFeatures,
    this.whiteboard,
    this.presentation,
    this.folder,
    this.virtualBg,
    this.bgm,
    this.resounds,
    this.themes,
    this.recordings,
    this.banner,
    this.chat,
    this.survey,
    this.screenShot,
    this.callToAction,
    this.meetingName,
    this.meetingDate,
    this.eventId,
    this.duration,
    this.createdBy,
    this.username,
    this.userEmail,
    this.userProfilePic,
    this.meetingType,
    this.count,
  });

  LibraryMeetingHistoryDatum copyWith({
    String? id,
    int? webinarVideo,
    int? allFeatures,
    int? whiteboard,
    int? presentation,
    int? folder,
    int? virtualBg,
    int? bgm,
    int? resounds,
    int? themes,
    int? recordings,
    int? banner,
    int? chat,
    int? survey,
    int? screenShot,
    int? callToAction,
    String? meetingName,
    DateTime? meetingDate,
    String? eventId,
    String? duration,
    int? createdBy,
    User? username,
    User? userEmail,
    dynamic userProfilePic,
    String? meetingType,
    int? count,
  }) =>
      LibraryMeetingHistoryDatum(
        id: id ?? this.id,
        webinarVideo: webinarVideo ?? this.webinarVideo,
        allFeatures: allFeatures ?? this.allFeatures,
        whiteboard: whiteboard ?? this.whiteboard,
        presentation: presentation ?? this.presentation,
        folder: folder ?? this.folder,
        virtualBg: virtualBg ?? this.virtualBg,
        bgm: bgm ?? this.bgm,
        resounds: resounds ?? this.resounds,
        themes: themes ?? this.themes,
        recordings: recordings ?? this.recordings,
        banner: banner ?? this.banner,
        chat: chat ?? this.chat,
        survey: survey ?? this.survey,
        screenShot: screenShot ?? this.screenShot,
        callToAction: callToAction ?? this.callToAction,
        meetingName: meetingName ?? this.meetingName,
        meetingDate: meetingDate ?? this.meetingDate,
        eventId: eventId ?? this.eventId,
        duration: duration ?? this.duration,
        createdBy: createdBy ?? this.createdBy,
        username: username ?? this.username,
        userEmail: userEmail ?? this.userEmail,
        userProfilePic: userProfilePic ?? this.userProfilePic,
        meetingType: meetingType ?? this.meetingType,
        count: count ?? this.count,
      );

  factory LibraryMeetingHistoryDatum.fromJson(Map<String, dynamic> json) => LibraryMeetingHistoryDatum(
        id: json["_id"],
        webinarVideo: json["webinar-video"],
        allFeatures: json["all-features"],
        whiteboard: json["whiteboard"],
        presentation: json["presentation"],
        folder: json["folder"],
        virtualBg: json["VirtualBg"],
        bgm: json["BGM"],
        resounds: json["Resounds"],
        themes: json["Themes"],
        recordings: json["Recordings"],
        banner: json["Banner"],
        chat: json["Chat"],
        survey: json["survey"],
        screenShot: json["ScreenShot"],
        callToAction: json["callToAction"],
        meetingName: json["meeting_name"],
        meetingDate: json["meeting_date"] == null ? null : DateTime.parse(json["meeting_date"]),
        eventId: json["event_id"],
        duration: json["duration"],
        createdBy: json["created_by"],
        username: userValues.map[json["username"]]!,
        userEmail: userValues.map[json["user_email"]]!,
        userProfilePic: json["user_profilePic"],
        meetingType: json["meeting_type"]!,
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "webinar-video": webinarVideo,
        "all-features": allFeatures,
        "whiteboard": whiteboard,
        "presentation": presentation,
        "folder": folder,
        "VirtualBg": virtualBg,
        "BGM": bgm,
        "Resounds": resounds,
        "Themes": themes,
        "Recordings": recordings,
        "Banner": banner,
        "Chat": chat,
        "survey": survey,
        "ScreenShot": screenShot,
        "callToAction": callToAction,
        "meeting_name": meetingName,
        "meeting_date": meetingDate?.toIso8601String(),
        "event_id": eventId,
        "duration": duration,
        "created_by": createdBy,
        "username": userValues.reverse[username],
        "user_email": userValues.reverse[userEmail],
        "user_profilePic": userProfilePic,
        "meeting_type": meetingTypeValues.reverse[meetingType],
        "count": count,
      };
}

enum MeetingType { WEBINAR }

final meetingTypeValues = EnumValues({"webinar": MeetingType.WEBINAR});

enum User { PAWAN_KALYAN, PK01_QA_O_MAILNOW_NET }

final userValues = EnumValues({"pawan kalyan": User.PAWAN_KALYAN, "pk01@qa.o-mailnow.net": User.PK01_QA_O_MAILNOW_NET});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

// import 'dart:convert';

// LibraryMeetingHistoryModel libraryMeetingHistoryModelFromJson(String str) => LibraryMeetingHistoryModel.fromJson(json.decode(str));

// String libraryMeetingHistoryModelToJson(LibraryMeetingHistoryModel data) => json.encode(data.toJson());

// class LibraryMeetingHistoryModel {
//   bool? status;
//   List<LibraryMeetingHistoryDatum>? libraryMeetingHistoryData;
//   int? totalRecordsCount;

//   LibraryMeetingHistoryModel({
//     this.status,
//     this.libraryMeetingHistoryData,
//     this.totalRecordsCount,
//   });

//   factory LibraryMeetingHistoryModel.fromJson(Map<String, dynamic> json) => LibraryMeetingHistoryModel(
//     status: json["status"],
//     libraryMeetingHistoryData: json["data"] == null ? [] : List<LibraryMeetingHistoryDatum>.from(json["data"]!.map((x) => LibraryMeetingHistoryDatum.fromJson(x))),
//     totalRecordsCount: json["totalRecordsCount"],
//   );

//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "data": libraryMeetingHistoryData == null ? [] : List<dynamic>.from(libraryMeetingHistoryData!.map((x) => x.toJson())),
//     "totalRecordsCount": totalRecordsCount,
//   };
// }

// class LibraryMeetingHistoryDatum {
//   String? id;
//   int? webinarVideo;
//   int? allFeatures;
//   int? whiteboard;
//   int? presentation;
//   int? virtualBg;
//   int? bgm;
//   int? resounds;
//   int? themes;
//   int? recordings;
//   int? chat;
//   int? survey;
//   int? screenShot;
//   int? callToAction;
//   String? meetingName;
//   DateTime? meetingDate;
//   String? eventId;
//   String? meetingType;
//   int? count;

//   LibraryMeetingHistoryDatum({
//     this.id,
//     this.webinarVideo,
//     this.allFeatures,
//     this.whiteboard,
//     this.presentation,
//     this.virtualBg,
//     this.bgm,
//     this.resounds,
//     this.themes,
//     this.recordings,
//     this.chat,
//     this.survey,
//     this.screenShot,
//     this.callToAction,
//     this.meetingName,
//     this.meetingDate,
//     this.eventId,
//     this.meetingType,
//     this.count,
//   });

//   factory LibraryMeetingHistoryDatum.fromJson(Map<String, dynamic> json) => LibraryMeetingHistoryDatum(
//     id: json["_id"],
//     webinarVideo: json["webinar-video"],
//     allFeatures: json["all-features"],
//     whiteboard: json["whiteboard"],
//     presentation: json["presentation"],
//     virtualBg: json["VirtualBg"],
//     bgm: json["BGM"],
//     resounds: json["Resounds"],
//     themes: json["Themes"],
//     recordings: json["Recordings"],
//     chat: json["Chat"],
//     survey: json["survey"],
//     screenShot: json["ScreenShot"],
//     callToAction: json["callToAction"],
//     meetingName: json["meeting_name"],
//     meetingDate: json["meeting_date"] == null ? null : DateTime.parse(json["meeting_date"]),
//     eventId: json["event_id"],
//     meetingType: json["meeting_type"],
//     count: json["count"],
//   );

//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "webinar-video": webinarVideo,
//     "all-features": allFeatures,
//     "whiteboard": whiteboard,
//     "presentation": presentation,
//     "VirtualBg": virtualBg,
//     "BGM": bgm,
//     "Resounds": resounds,
//     "Themes": themes,
//     "Recordings": recordings,
//     "Chat": chat,
//     "survey": survey,
//     "ScreenShot": screenShot,
//     "callToAction": callToAction,
//     "meeting_name": meetingName,
//     "meeting_date": meetingDate?.toIso8601String(),
//     "event_id": eventId,
//     "meeting_type":meetingType,
//     "count": count,
//   };
// }

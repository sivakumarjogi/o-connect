// // To parse this JSON data, do
// //
// //     final dashboardBannerModel = dashboardBannerModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final libraryFilesModel = libraryFilesModelFromJson(jsonString);

// ignore_for_file: sdk_version_since

import 'dart:convert';

DashboardBannerModel dashboardBannerModelFromJson(String str) => DashboardBannerModel.fromJson(json.decode(str));

String dashboardBannerModelToJson(DashboardBannerModel data) => json.encode(data.toJson());

class DashboardBannerModel {
  bool status;
  List<DashboardBannerModelData> data;

  DashboardBannerModel({
    required this.status,
    required this.data,
  });

  DashboardBannerModel copyWith({
    bool? status,
    List<DashboardBannerModelData>? data,
    int? count,
    String? currentRegion,
  }) =>
      DashboardBannerModel(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory DashboardBannerModel.fromJson(Map<String, dynamic> json) => DashboardBannerModel(
        status: json["status"],
        data: List<DashboardBannerModelData>.from(json["data"].map((x) => DashboardBannerModelData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DashboardBannerModelData {
  String? id;
  int? userId;
  String? purpose;
  dynamic fileSize;
  DateTime? createdOn;
  int? createdBy;
  DateTime? updatedOn;
  int? updatedBy;
  int? isDeleted;
  String? fileType;
  String? folderName;
  int? a;
  int? folderSize;
  int? filesCount;
  String? meetingId;
  String? fileName;
  String? url;
  String? readUrl;
  int? recordFlag;
  bool? inProgress;

  DashboardBannerModelData({
    this.id,
    this.userId,
    this.purpose,
    this.fileSize,
    this.createdOn,
    this.createdBy,
    this.updatedOn,
    this.updatedBy,
    this.isDeleted,
    this.fileType,
    this.folderName,
    this.a,
    this.folderSize,
    this.filesCount,
    this.meetingId,
    this.fileName,
    this.url,
    this.readUrl,
    this.recordFlag,
    this.inProgress,
  });

  DashboardBannerModelData copyWith({
    String? id,
    int? userId,
    String? purpose,
    dynamic fileSize,
    DateTime? createdOn,
    int? createdBy,
    DateTime? updatedOn,
    int? updatedBy,
    int? isDeleted,
    String? fileType,
    String? folderName,
    int? a,
    int? folderSize,
    int? filesCount,
    String? meetingId,
    String? fileName,
    String? url,
    String? readUrl,
    int? recordFlag,
    bool? inProgress,
  }) =>
      DashboardBannerModelData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        purpose: purpose ?? this.purpose,
        fileSize: fileSize ?? this.fileSize,
        createdOn: createdOn ?? this.createdOn,
        createdBy: createdBy ?? this.createdBy,
        updatedOn: updatedOn ?? this.updatedOn,
        updatedBy: updatedBy ?? this.updatedBy,
        isDeleted: isDeleted ?? this.isDeleted,
        fileType: fileType ?? this.fileType,
        folderName: folderName ?? this.folderName,
        a: a ?? this.a,
        folderSize: folderSize ?? this.folderSize,
        filesCount: filesCount ?? this.filesCount,
        meetingId: meetingId ?? this.meetingId,
        fileName: fileName ?? this.fileName,
        url: url ?? this.url,
        readUrl: readUrl ?? this.readUrl,
        recordFlag: recordFlag ?? this.recordFlag,
        inProgress: inProgress ?? this.inProgress,
      );

  factory DashboardBannerModelData.fromJson(Map<String, dynamic> json) => DashboardBannerModelData(
        id: json["_id"],
        userId: json["user_id"],
        purpose: json["purpose"],
        fileSize: json["file_size"],
        createdOn: DateTime.parse(json["created_on"]),
        createdBy: json["created_by"],
        updatedOn: DateTime.parse(json["updated_on"]),
        updatedBy: json["updated_by"],
        isDeleted: json["is_deleted"],
        fileType: json["file_type"],
        folderName: json["folderName"],
        a: json["a"],
        folderSize: json["folder_size"],
        filesCount: json["files_count"],
        meetingId: json["meeting_id"],
        fileName: json["file_name"],
        url: json["url"],
        readUrl: json["readUrl"],
        recordFlag: json["record_flag"],
        inProgress: json["inProgress"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "purpose": purpose,
        "file_size": fileSize,
        "created_on": createdOn?.toIso8601String(),
        "created_by": createdBy,
        "updated_on": updatedOn?.toIso8601String(),
        "updated_by": updatedBy,
        "is_deleted": isDeleted,
        "file_type": fileType,
        "folderName": folderName,
        "a": a,
        "folder_size": folderSize,
        "files_count": filesCount,
        "meeting_id": meetingId,
        "file_name": fileName,
        "url": url,
        "readUrl": readUrl,
        "record_flag": recordFlag,
        "inProgress": inProgress,
      };
}


/*

{
	"0": {
		"FileExt": "png",
		"FileId": "6554c8c2e2256a0008e6f2cb",
		"FileName": "Screenshot 2023-05-25 114923.png",
		"FileSize": "64392",
		"Url": "https://df8wbawj934ec.cloudfront.net/uploads/4456047/Screenshot%202023-05-25%20114923.png",
		"id": 0
	}
}

 */
  


// import 'dart:convert';

// DashboardBannerModel dashboardBannerModelFromJson(String str) => DashboardBannerModel.fromJson(json.decode(str));

// String dashboardBannerModelToJson(DashboardBannerModel data) => json.encode(data.toJson());

// class DashboardBannerModel {
//     bool? status;
//     List<DashboardBannerModelData> data;
//     int? count;
//     String? currentRegion;

//     DashboardBannerModel({
//         this.status,
//         required this.data,
//         this.count,
//         this.currentRegion,
//     });

//     DashboardBannerModel copyWith({
//         bool? status,
//         List<DashboardBannerModelData>? data,
//         int? count,
//         String? currentRegion,
//     }) => 
//         DashboardBannerModel(
//             status: status ?? this.status,
//             data: data ?? this.data,
//             count: count ?? this.count,
//             currentRegion: currentRegion ?? this.currentRegion,
//         );

//     factory DashboardBannerModel.fromJson(Map<String, dynamic> json) => DashboardBannerModel(
//         status: json["status"],
//         data: json["data"] == null ? [] : List<DashboardBannerModelData>.from(json["data"]!.map((x) => DashboardBannerModelData.fromJson(x))),
//         count: json["count"],
//         currentRegion: json["currentRegion"],
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "data":  List<dynamic>.from(data.map((x) => x.toJson())),
//         "count": count,
//         "currentRegion": currentRegion,
//     };
// }

// class DashboardBannerModelData {
//     String? id;
//     int? userId;
//     String? purpose;
//     String? fileSize;
//     DateTime? createdOn;
//     int? createdBy;
//     DateTime? updatedOn;
//     int? updatedBy;
//     int? isDeleted;
//     String? fileName;
//     String? fileType;
//     String? url;
//     String? readUrl;
//     int? recordFlag;
//     int? a;
//     int? folderSize;
//     int? filesCount;

//     DashboardBannerModelData({
//         this.id,
//         this.userId,
//         this.purpose,
//         this.fileSize,
//         this.createdOn,
//         this.createdBy,
//         this.updatedOn,
//         this.updatedBy,
//         this.isDeleted,
//         this.fileName,
//         this.fileType,
//         this.url,
//         this.readUrl,
//         this.recordFlag,
//         this.a,
//         this.folderSize,
//         this.filesCount,
//     });

//     DashboardBannerModelData copyWith({
//         String? id,
//         int? userId,
//         String? purpose,
//         String? fileSize,
//         DateTime? createdOn,
//         int? createdBy,
//         DateTime? updatedOn,
//         int? updatedBy,
//         int? isDeleted,
//         String? fileName,
//         String? fileType,
//         String? url,
//         String? readUrl,
//         int? recordFlag,
//         int? a,
//         int? folderSize,
//         int? filesCount,
//     }) => 
//         DashboardBannerModelData(
//             id: id ?? this.id,
//             userId: userId ?? this.userId,
//             purpose: purpose ?? this.purpose,
//             fileSize: fileSize ?? this.fileSize,
//             createdOn: createdOn ?? this.createdOn,
//             createdBy: createdBy ?? this.createdBy,
//             updatedOn: updatedOn ?? this.updatedOn,
//             updatedBy: updatedBy ?? this.updatedBy,
//             isDeleted: isDeleted ?? this.isDeleted,
//             fileName: fileName ?? this.fileName,
//             fileType: fileType ?? this.fileType,
//             url: url ?? this.url,
//             readUrl: readUrl ?? this.readUrl,
//             recordFlag: recordFlag ?? this.recordFlag,
//             a: a ?? this.a,
//             folderSize: folderSize ?? this.folderSize,
//             filesCount: filesCount ?? this.filesCount,
//         );

//     factory DashboardBannerModelData.fromJson(Map<String, dynamic> json) => DashboardBannerModelData(
//         id: json["_id"],
//         userId: json["user_id"],
//         purpose: json["purpose"],
//         fileSize: json["file_size"],
//         createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
//         createdBy: json["created_by"],
//         updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
//         updatedBy: json["updated_by"],
//         isDeleted: json["is_deleted"],
//         fileName: json["file_name"],
//         fileType: json["file_type"],
//         url: json["url"],
//         readUrl: json["readUrl"],
//         recordFlag: json["record_flag"],
//         a: json["a"],
//         folderSize: json["folder_size"],
//         filesCount: json["files_count"],
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "user_id": userId,
//         "purpose": purpose,
//         "file_size": fileSize,
//         "created_on": createdOn?.toIso8601String(),
//         "created_by": createdBy,
//         "updated_on": updatedOn?.toIso8601String(),
//         "updated_by": updatedBy,
//         "is_deleted": isDeleted,
//         "file_name": fileName,
//         "file_type": fileType,
//         "url": url,
//         "readUrl": readUrl,
//         "record_flag": recordFlag,
//         "a": a,
//         "folder_size": folderSize,
//         "files_count": filesCount,
//     };
// }

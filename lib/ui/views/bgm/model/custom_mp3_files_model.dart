// To parse this JSON data, do
//
//     final customBgmFilesModel = customBgmFilesModelFromJson(jsonString);

import 'dart:convert';

CustomMp3FilesModel CustomMp3FilesModelFromJson(String str) => CustomMp3FilesModel.fromJson(json.decode(str));

String CustomMp3FilesModelToJson(CustomMp3FilesModel data) => json.encode(data.toJson());

class CustomMp3FilesModel{
    String? id;
    int? createdBy;
    DateTime? createdOn;
    String? fileName;
    String? fileSize;
    String? fileType;
    String? meetingId;
    String? purpose;
    int? recordFlag;
    int? updatedBy;
    DateTime? updatedOn;
    String? url;
    int? userId;
    String? category;
    String? readUrl;

    CustomMp3FilesModel({
        this.id,
        this.createdBy,
        this.createdOn,
        this.fileName,
        this.fileSize,
        this.fileType,
        this.meetingId,
        this.purpose,
        this.recordFlag,
        this.updatedBy,
        this.updatedOn,
        this.url,
        this.userId,
        this.category,
        this.readUrl,
    });

    factory CustomMp3FilesModel.fromJson(Map<String, dynamic> json) => CustomMp3FilesModel(
        id: json["_id"],
        createdBy: json["created_by"],
        createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
        fileName: json["file_name"],
        fileSize: json["file_size"],
        fileType: json["file_type"],
        meetingId: json["meeting_id"],
        purpose: json["purpose"],
        recordFlag: json["record_flag"],
        updatedBy: json["updated_by"],
        updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
        url: json["url"],
        userId: json["user_id"],
        category: json["category"],
        readUrl: json["readUrl"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "created_by": createdBy,
        "created_on": createdOn?.toIso8601String(),
        "file_name": fileName,
        "file_size": fileSize,
        "file_type": fileType,
        "meeting_id": meetingId,
        "purpose": purpose,
        "record_flag": recordFlag,
        "updated_by": updatedBy,
        "updated_on": updatedOn?.toIso8601String(),
        "url": url,
        "user_id": userId,
        "category": category,
        "readUrl": readUrl,
    };
}

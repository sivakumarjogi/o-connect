// To parse this JSON data, do
//
//     final presentationUploadFilesModel = presentationUploadFilesModelFromJson(jsonString);

import 'dart:convert';

PresentationUploadFilesModel presentationUploadFilesModelFromJson(String str) => PresentationUploadFilesModel.fromJson(json.decode(str));

String presentationUploadFilesModelToJson(PresentationUploadFilesModel data) => json.encode(data.toJson());

class PresentationUploadFilesModel {
  bool? status;
  Data? data;

  PresentationUploadFilesModel({
    this.status,
    this.data,
  });

  factory PresentationUploadFilesModel.fromJson(Map<String, dynamic> json) => PresentationUploadFilesModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  int? userId;
  String? fileName;
  String? fileType;
  String? fileSize;
  DateTime? createdOn;
  int? createdBy;
  DateTime? updatedOn;
  int? updatedBy;
  String? url;
  String? readUrl;
  int? recordFlag;
  String? purpose;
  String? id;

  Data({
    this.userId,
    this.fileName,
    this.fileType,
    this.fileSize,
    this.createdOn,
    this.createdBy,
    this.updatedOn,
    this.updatedBy,
    this.url,
    this.readUrl,
    this.recordFlag,
    this.purpose,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    fileName: json["file_name"],
    fileType: json["file_type"],
    fileSize: json["file_size"],
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
    createdBy: json["created_by"],
    updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
    updatedBy: json["updated_by"],
    url: json["url"],
    readUrl: json["readUrl"],
    recordFlag: json["record_flag"],
    purpose: json["purpose"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "file_name": fileName,
    "file_type": fileType,
    "file_size": fileSize,
    "created_on": createdOn?.toIso8601String(),
    "created_by": createdBy,
    "updated_on": updatedOn?.toIso8601String(),
    "updated_by": updatedBy,
    "url": url,
    "readUrl": readUrl,
    "record_flag": recordFlag,
    "purpose": purpose,
    "_id": id,
  };
}

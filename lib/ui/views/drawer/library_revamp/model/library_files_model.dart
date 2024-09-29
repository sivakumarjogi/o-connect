// To parse this JSON data, do
//
//     final libraryFilesModel = libraryFilesModelFromJson(jsonString);

// ignore_for_file: sdk_version_since

import 'dart:convert';

import 'package:o_connect/core/models/library_model/presentation_data_model.dart';
import 'package:o_connect/ui/views/meeting/utils/get_svg_file_extension.dart';

LibraryFilesModel libraryFilesModelFromJson(String str) => LibraryFilesModel.fromJson(json.decode(str));

String libraryFilesModelToJson(LibraryFilesModel data) => json.encode(data.toJson());

class LibraryFilesModel {
  bool status;
  List<LibraryItem> data;

  LibraryFilesModel({
    required this.status,
    required this.data,
  });

  LibraryFilesModel copyWith({
    bool? status,
    List<LibraryItem>? data,
    int? count,
    String? currentRegion,
  }) =>
      LibraryFilesModel(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory LibraryFilesModel.fromJson(Map<String, dynamic> json) => LibraryFilesModel(
        status: json["status"],
        data: List<LibraryItem>.from(json["data"].map((x) => LibraryItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class LibraryItem {
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
  List<ConvertedImage>? convertedImages;
  bool? canShow;
  bool? isSelected;
  bool get isPresentationItem {
    String fileExt = ((fileName ?? "").split(".").last);
    bool isValidFormat = !(fileExt.isVideoFormat || fileExt.isAudioFormat);
    return (isFolder || isValidFormat);
  }

  bool get isFolder => fileType == "folder";
  PresentationDataModel getPresentationModelFromLibrary({
    required int ou,
  }) {
    List<ConvertedImage> images = (convertedImages ?? []).isNotEmpty
        ? convertedImages!
        : [
            ConvertedImage(
              url: readUrl ?? "",
              fileExt: fileType ?? "",
            )
          ];
    List<PresentationImage> finalImagesList = [];
    for (var element in images.indexed) {
      finalImagesList.add(PresentationImage(
        fileExt: element.$2.url.split(".").last,
        fileId: id ?? "",
        fileName: element.$2.url.split("/").last,
        fileSize: fileSize ?? "",
        id: element.$1 + 1,
        url: element.$2.url,
      ));
    }
    return PresentationDataModel(
      presentationImages: finalImagesList,
      fileName: fileName ?? "",
      fileType: fileType ?? "",
      height: images.isNotEmpty ? images.first.height.toDouble() : 1032.0,
      width: images.isNotEmpty ? images.first.width.toDouble() : 940,
      ou: ou,
      pId: 1,
      presentationUrl: readUrl ?? "",
    );
  }

  LibraryItem({
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
    this.convertedImages,
    this.canShow,
    this.isSelected,
  });

  LibraryItem copyWith({
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
    List<ConvertedImage>? convertedImages,
    bool? canShow,
    bool? isSelected,
  }) =>
      LibraryItem(
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
        convertedImages: convertedImages ?? this.convertedImages,
        canShow: canShow ?? this.canShow,
        isSelected: isSelected ?? this.isSelected,
      );

  factory LibraryItem.fromJson(Map<String, dynamic> json) => LibraryItem(
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
        convertedImages: json["convertedImages"] == null ? [] : List<ConvertedImage>.from(json["convertedImages"]!.map((x) => ConvertedImage.fromJson(x))),
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
        "convertedImages": convertedImages == null ? [] : List<dynamic>.from(convertedImages!.map((x) => x.toJson())),
      };
}

class ConvertedImage {
  String url;
  String fileExt;
  int width;
  int height;

  ConvertedImage({
    required this.url,
    required this.fileExt,
    this.width = 940,
    this.height = 1032,
  });
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
  ConvertedImage copyWith({
    String? url,
    String? fileExt,
    int? width,
    int? height,
  }) =>
      ConvertedImage(
        url: url ?? this.url,
        fileExt: fileExt ?? this.fileExt,
        width: width ?? this.width,
        height: height ?? this.height,
      );

  factory ConvertedImage.fromJson(Map<String, dynamic> json) {
    return ConvertedImage(
      url: json["Url"],
      fileExt: json["FileExt"],
      width: json["Width"] ?? 940,
      height: json["Height"] ?? 1032,
    );
  }

  Map<String, dynamic> toJson() => {
        "Url": url,
        "FileExt": fileExt,
        "Width": width,
        "Height": height,
      };
}

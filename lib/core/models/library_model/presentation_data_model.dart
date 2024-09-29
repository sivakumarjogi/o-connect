// To parse this JSON data, do
//
//     final presentationDataModel = presentationDataModelFromJson(jsonString);

import 'dart:convert';

PresentationDataModel presentationDataModelFromJson(String str) => PresentationDataModel.fromJson(json.decode(str));

String presentationDataModelToJson(PresentationDataModel data) => json.encode(data.toJson());

class PresentationDataModel {
  List<PresentationImage> presentationImages;
  String fileName;
  String fileType;
  double height;
  int ou;
  int pId;
  String presentationUrl;
  double width;

  PresentationDataModel({
    required this.presentationImages,
    required this.fileName,
    required this.fileType,
    required this.height,
    required this.ou,
    required this.pId,
    required this.presentationUrl,
    required this.width,
  });

  PresentationDataModel copyWith({
    List<PresentationImage>? presentationImages,
    String? fileName,
    String? fileType,
    double? height,
    int? ou,
    int? pId,
    String? presentationUrl,
    double? width,
  }) =>
      PresentationDataModel(
        presentationImages: presentationImages ?? this.presentationImages,
        fileName: fileName ?? this.fileName,
        fileType: fileType ?? this.fileType,
        height: height ?? this.height,
        ou: ou ?? this.ou,
        pId: pId ?? this.pId,
        presentationUrl: presentationUrl ?? this.presentationUrl,
        width: width ?? this.width,
      );

  factory PresentationDataModel.fromJson(Map<String, dynamic> json) => PresentationDataModel(
        presentationImages: List<PresentationImage>.from(json["data"].map(
          (x) => PresentationImage.fromJson(x),
        )),
        fileName: json["file_name"],
        fileType: json["fileType"],
        height: json["height"]?.toDouble(),
        ou: json["ou"],
        pId: json["pId"],
        presentationUrl: json["presentationUrl"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(presentationImages.map((x) => x.toJson())),
        "file_name": fileName,
        "fileType": fileType,
        "height": height,
        "ou": ou,
        "pId": pId,
        "presentationUrl": presentationUrl,
        "width": width,
      };
}

class PresentationImage {
  String fileExt;
  String fileId;
  String fileName;
  String fileSize;
  int id;
  String url;

  PresentationImage({
    required this.fileExt,
    required this.fileId,
    required this.fileName,
    required this.fileSize,
    required this.id,
    required this.url,
  });

  PresentationImage copyWith({
    String? fileExt,
    String? fileId,
    String? fileName,
    String? fileSize,
    int? id,
    String? url,
  }) =>
      PresentationImage(
        fileExt: fileExt ?? this.fileExt,
        fileId: fileId ?? this.fileId,
        fileName: fileName ?? this.fileName,
        fileSize: fileSize ?? this.fileSize,
        id: id ?? this.id,
        url: url ?? this.url,
      );

  factory PresentationImage.fromJson(Map<String, dynamic> json) => PresentationImage(
        fileExt: json["FileExt"],
        fileId: json["FileId"],
        fileName: json["FileName"],
        fileSize: json["FileSize"],
        id: json["id"],
        url: json["Url"],
      );

  Map<String, dynamic> toJson() => {
        "FileExt": fileExt,
        "FileId": fileId,
        "FileName": fileName,
        "FileSize": fileSize,
        "id": id,
        "Url": url,
      };
}

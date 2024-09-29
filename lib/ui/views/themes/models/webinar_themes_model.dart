// To parse this JSON data, do
//
//     final webinarThemesModel = webinarThemesModelFromJson(jsonString);

import 'dart:convert';

WebinarThemesModel webinarThemesModelFromJson(String str) => WebinarThemesModel.fromJson(json.decode(str));

String webinarThemesModelToJson(WebinarThemesModel data) => json.encode(data.toJson());

class WebinarThemesModel {
  bool? status;
  List<WebinarThemesListModel>? data;

  WebinarThemesModel({
    this.status,
    this.data,
  });

  factory WebinarThemesModel.fromJson(Map<String, dynamic> json) => WebinarThemesModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<WebinarThemesListModel>.from(json["data"]!.map((x) => WebinarThemesListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class WebinarThemesListModel {
  String? id;
  String? category;
  String? name;
  String? type;
  String? fileName;
  String? backgroundImageUrl;
  String? chatUrl;
  String? onScreenUrl;
  String? animation1Url;
  String? animation2Url;
  bool? isNew;

  WebinarThemesListModel({
    this.id,
    this.category,
    this.name,
    this.type,
    this.fileName,
    this.backgroundImageUrl,
    this.chatUrl,
    this.onScreenUrl,
    this.animation1Url,
    this.animation2Url,
    this.isNew,
  });

  WebinarThemesListModel copyWith({
    String? id,
    String? category,
    String? name,
    String? type,
    String? fileName,
    String? backgroundImageUrl,
    String? chatUrl,
    String? onScreenUrl,
    String? animation1Url,
    String? animation2Url,
  }) =>
      WebinarThemesListModel(
        id: id ?? this.id,
        category: category ?? this.category,
        name: name ?? this.name,
        type: type ?? this.type,
        fileName: fileName ?? this.fileName,
        backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
        chatUrl: chatUrl ?? this.chatUrl,
        onScreenUrl: onScreenUrl ?? this.onScreenUrl,
        animation1Url: animation1Url ?? this.animation1Url,
        animation2Url: animation2Url ?? this.animation2Url,
      );

  factory WebinarThemesListModel.fromJson(Map<String, dynamic> json) => WebinarThemesListModel(
        id: json["_id"],
        category: json["category"],
        name: json["name"],
        type: json["type"],
        fileName: json["fileName"],
        backgroundImageUrl: json["backgroundImageUrl"],
        chatUrl: json["chatUrl"],
        onScreenUrl: json["onScreenUrl"],
        animation1Url: json["animation1Url"],
        animation2Url: json["animation2Url"],
        isNew: json['isNew'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category": category,
        "name": name,
        "type": type,
        "fileName": fileName,
        "backgroundImageUrl": backgroundImageUrl,
        "chatUrl": chatUrl,
        "onScreenUrl": onScreenUrl,
        "animation1Url": animation1Url,
        "animation2Url": animation2Url,
        "isNew": isNew,
      };
}

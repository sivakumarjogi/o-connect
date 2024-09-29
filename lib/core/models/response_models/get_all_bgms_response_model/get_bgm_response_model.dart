// To parse this JSON data, do
//
//     final getBgmResponseModel = getBgmResponseModelFromJson(jsonString);

import 'dart:convert';

GetBgmResponseModel getBgmResponseModelFromJson(String str) =>
    GetBgmResponseModel.fromJson(json.decode(str));

String getBgmResponseModelToJson(GetBgmResponseModel data) =>
    json.encode(data.toJson());

class GetBgmResponseModel {
  bool status;
  List<GetBgmResponseModelDatum> data;

  GetBgmResponseModel({
    required this.status,
    required this.data,
  });

  factory GetBgmResponseModel.fromJson(Map<String, dynamic> json) =>
      GetBgmResponseModel(
        status: json["status"],
        data: List<GetBgmResponseModelDatum>.from(
            json["data"].map((x) => GetBgmResponseModelDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GetBgmResponseModelDatum {
  String category;
  List<PurpleDatum> data;

  GetBgmResponseModelDatum({
    required this.category,
    required this.data,
  });

  factory GetBgmResponseModelDatum.fromJson(Map<String, dynamic> json) =>
      GetBgmResponseModelDatum(
        category: json["category"],
        data: List<PurpleDatum>.from(
            json["data"].map((x) => PurpleDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PurpleDatum {
  String subCategory;
  List<FluffyDatum> data;

  PurpleDatum({
    required this.subCategory,
    required this.data,
  });

  factory PurpleDatum.fromJson(Map<String, dynamic> json) => PurpleDatum(
        subCategory: json["subCategory"],
        data: List<FluffyDatum>.from(
            json["data"].map((x) => FluffyDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subCategory": subCategory,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FluffyDatum {
  String name;
  String url;

  FluffyDatum({
    required this.name,
    required this.url,
  });

  factory FluffyDatum.fromJson(Map<String, dynamic> json) => FluffyDatum(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}

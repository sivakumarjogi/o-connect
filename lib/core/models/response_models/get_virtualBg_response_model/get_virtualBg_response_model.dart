// To parse this JSON data, do
//
//     final getVirtualBgModel = getVirtualBgModelFromJson(jsonString);

import 'dart:convert';

GetVirtualBgModel getVirtualBgModelFromJson(String str) => GetVirtualBgModel.fromJson(json.decode(str));

String getVirtualBgModelToJson(GetVirtualBgModel data) => json.encode(data.toJson());

class GetVirtualBgModel {
    bool status;
    List<GetVirtualBgModelDatum> data;

    GetVirtualBgModel({
        required this.status,
        required this.data,
    });

    factory GetVirtualBgModel.fromJson(Map<String, dynamic> json) => GetVirtualBgModel(
        status: json["status"],
        data: List<GetVirtualBgModelDatum>.from(json["data"].map((x) => GetVirtualBgModelDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class GetVirtualBgModelDatum {
    String category;
    List<PurpleDatum> data;

    GetVirtualBgModelDatum({
        required this.category,
        required this.data,
    });

    factory GetVirtualBgModelDatum.fromJson(Map<String, dynamic> json) => GetVirtualBgModelDatum(
        category: json["category"],
        data: List<PurpleDatum>.from(json["data"].map((x) => PurpleDatum.fromJson(x))),
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
        data: List<FluffyDatum>.from(json["data"].map((x) => FluffyDatum.fromJson(x))),
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

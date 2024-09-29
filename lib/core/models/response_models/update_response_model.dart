// To parse this JSON data, do
//
//     final updateResponseModel = updateResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateResponseModel updateResponseModelFromJson(String str) => UpdateResponseModel.fromJson(json.decode(str));

String updateResponseModelToJson(UpdateResponseModel data) => json.encode(data.toJson());

class UpdateResponseModel {
    int statusCode;
    String status;
    String message;
    dynamic data;
    dynamic body;
    dynamic totalCount;

    UpdateResponseModel({
        required this.statusCode,
        required this.status,
        required this.message,
        required this.data,
        required this.body,
        required this.totalCount,
    });

    factory UpdateResponseModel.fromJson(Map<String, dynamic> json) => UpdateResponseModel(
        statusCode: json["statusCode"],
        status: json["status"],
        message: json["message"],
        data: json["data"],
        body: json["body"],
        totalCount: json["totalCount"],
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "status": status,
        "message": message,
        "data": data,
        "body": body,
        "totalCount": totalCount,
    };
}

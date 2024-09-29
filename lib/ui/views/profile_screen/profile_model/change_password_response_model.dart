// To parse this JSON data, do
//
//     final getChangePasswordResponseModel = getChangePasswordResponseModelFromJson(jsonString);

import 'dart:convert';

GetChangePasswordResponseModel getChangePasswordResponseModelFromJson(
        String str) =>
    GetChangePasswordResponseModel.fromJson(json.decode(str));

String getChangePasswordResponseModelToJson(
        GetChangePasswordResponseModel data) =>
    json.encode(data.toJson());

class GetChangePasswordResponseModel {
  int? statusCode;
  String? status;
  String? message;
  dynamic data;
  dynamic body;
  dynamic totalCount;

  GetChangePasswordResponseModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.body,
    this.totalCount,
  });

  factory GetChangePasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      GetChangePasswordResponseModel(
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

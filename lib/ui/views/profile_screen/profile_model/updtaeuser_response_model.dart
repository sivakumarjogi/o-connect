// To parse this JSON data, do
//
//     final getUpdateUserResponseModel = getUpdateUserResponseModelFromJson(jsonString);

import 'dart:convert';

GetUpdateUserResponseModel getUpdateUserResponseModelFromJson(String str) =>
    GetUpdateUserResponseModel.fromJson(json.decode(str));

String getUpdateUserResponseModelToJson(GetUpdateUserResponseModel data) =>
    json.encode(data.toJson());

class GetUpdateUserResponseModel {
  int? statusCode;
  String? status;
  String? message;
  String? data;
  dynamic body;
  dynamic totalCount;

  GetUpdateUserResponseModel({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.body,
    this.totalCount,
  });

  factory GetUpdateUserResponseModel.fromJson(Map<String, dynamic> json) =>
      GetUpdateUserResponseModel(
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

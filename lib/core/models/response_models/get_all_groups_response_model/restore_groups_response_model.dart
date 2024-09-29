import 'package:json_annotation/json_annotation.dart';

part 'restore_groups_response_model.g.dart';

@JsonSerializable()
class RestoreGroupsResponseModel {
  int statusCode;
  String status;
  String message;
  dynamic data;
  dynamic body;
  dynamic totalCount;

  RestoreGroupsResponseModel({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
    required this.body,
    required this.totalCount,
  });

  factory RestoreGroupsResponseModel.fromJson(Map<String, dynamic> json) => RestoreGroupsResponseModel(
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

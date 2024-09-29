import 'package:json_annotation/json_annotation.dart';

part 'permanent_delete_group_response_model.g.dart';

@JsonSerializable()
class PermanentDeleteGroupResponseModel {
  int statusCode;
  String status;
  String message;
  dynamic data;
  dynamic body;
  dynamic totalCount;

  PermanentDeleteGroupResponseModel({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
    required this.body,
    required this.totalCount,
  });

  factory PermanentDeleteGroupResponseModel.fromJson(Map<String, dynamic> json) => PermanentDeleteGroupResponseModel(
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

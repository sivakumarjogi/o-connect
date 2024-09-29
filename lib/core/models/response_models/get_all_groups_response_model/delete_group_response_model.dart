import 'package:json_annotation/json_annotation.dart';

part 'delete_group_response_model.g.dart';

@JsonSerializable()

class DeleteGroupResponseModel {
  int statusCode;
  String status;
  String message;
  dynamic data;
  dynamic body;
  dynamic totalCount;

  DeleteGroupResponseModel({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
    required this.body,
    required this.totalCount,
  });

  factory DeleteGroupResponseModel.fromJson(Map<String, dynamic> json) => DeleteGroupResponseModel(
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

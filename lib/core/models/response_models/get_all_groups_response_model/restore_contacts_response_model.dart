import 'package:json_annotation/json_annotation.dart';

part 'restore_contacts_response_model.g.dart';

@JsonSerializable()

class RestoreContactResponseModel {
  int statusCode;
  String status;
  String message;
  dynamic data;
  dynamic body;
  dynamic totalCount;

  RestoreContactResponseModel({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
    required this.body,
    required this.totalCount,
  });

  factory RestoreContactResponseModel.fromJson(Map<String, dynamic> json) => RestoreContactResponseModel(
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

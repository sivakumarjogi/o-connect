import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class ResponseModel {
  int statusCode;
  String status;
  String message;
  dynamic data;
  dynamic body;
  dynamic totalCount;

  ResponseModel({
    required this.statusCode,
    required this.status,
    required this.message,
     this.data,
     this.body,
    this.totalCount,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}



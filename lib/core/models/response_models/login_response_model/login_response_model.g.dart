// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) =>
    ResponseModel(
      statusCode: json['statusCode'] as int,
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'],
      body: json['body'],
      totalCount: json['totalCount'],
    );

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'body': instance.body,
      'totalCount': instance.totalCount,
    };

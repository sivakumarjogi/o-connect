// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permanent_delete_group_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermanentDeleteGroupResponseModel _$PermanentDeleteGroupResponseModelFromJson(
        Map<String, dynamic> json) =>
    PermanentDeleteGroupResponseModel(
      statusCode: json['statusCode'] as int,
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'],
      body: json['body'],
      totalCount: json['totalCount'],
    );

Map<String, dynamic> _$PermanentDeleteGroupResponseModelToJson(
        PermanentDeleteGroupResponseModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'body': instance.body,
      'totalCount': instance.totalCount,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_group_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteGroupResponseModel _$DeleteGroupResponseModelFromJson(
        Map<String, dynamic> json) =>
    DeleteGroupResponseModel(
      statusCode: json['statusCode'] as int,
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'],
      body: json['body'],
      totalCount: json['totalCount'],
    );

Map<String, dynamic> _$DeleteGroupResponseModelToJson(
        DeleteGroupResponseModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'body': instance.body,
      'totalCount': instance.totalCount,
    };

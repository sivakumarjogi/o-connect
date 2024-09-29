// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restore_groups_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestoreGroupsResponseModel _$RestoreGroupsResponseModelFromJson(
        Map<String, dynamic> json) =>
    RestoreGroupsResponseModel(
      statusCode: json['statusCode'] as int,
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'],
      body: json['body'],
      totalCount: json['totalCount'],
    );

Map<String, dynamic> _$RestoreGroupsResponseModelToJson(
        RestoreGroupsResponseModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'body': instance.body,
      'totalCount': instance.totalCount,
    };

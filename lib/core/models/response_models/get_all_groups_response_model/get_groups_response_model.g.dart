// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_groups_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllGroupsResponseModel _$GetAllGroupsResponseModelFromJson(
        Map<String, dynamic> json) =>
    GetAllGroupsResponseModel(
      statusCode: json['statusCode'] as int,
      status: json['status'] as String,
      message: json['message'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
      body: json['body'],
      totalCount: json['totalCount'],
    );

Map<String, dynamic> _$GetAllGroupsResponseModelToJson(
        GetAllGroupsResponseModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'body': instance.body,
      'totalCount': instance.totalCount,
    };

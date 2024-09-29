// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_contacts_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteContactResponseModel _$DeleteContactResponseModelFromJson(
        Map<String, dynamic> json) =>
    DeleteContactResponseModel(
      statusCode: json['statusCode'] as int,
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'],
      body: json['body'],
      totalCount: json['totalCount'],
    );

Map<String, dynamic> _$DeleteContactResponseModelToJson(
        DeleteContactResponseModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'body': instance.body,
      'totalCount': instance.totalCount,
    };

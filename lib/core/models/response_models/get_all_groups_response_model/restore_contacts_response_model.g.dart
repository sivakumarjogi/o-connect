// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restore_contacts_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestoreContactResponseModel _$RestoreContactResponseModelFromJson(
        Map<String, dynamic> json) =>
    RestoreContactResponseModel(
      statusCode: json['statusCode'] as int,
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'],
      body: json['body'],
      totalCount: json['totalCount'],
    );

Map<String, dynamic> _$RestoreContactResponseModelToJson(
        RestoreContactResponseModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'body': instance.body,
      'totalCount': instance.totalCount,
    };

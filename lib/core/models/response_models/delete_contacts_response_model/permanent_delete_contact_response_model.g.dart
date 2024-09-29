// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permanent_delete_contact_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermanentDeleteContactResponseModel
    _$PermanentDeleteContactResponseModelFromJson(Map<String, dynamic> json) =>
        PermanentDeleteContactResponseModel(
          statusCode: json['statusCode'] as int,
          status: json['status'] as String,
          message: json['message'] as String,
          data: json['data'],
          body: json['body'],
          totalCount: json['totalCount'],
        );

Map<String, dynamic> _$PermanentDeleteContactResponseModelToJson(
        PermanentDeleteContactResponseModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'body': instance.body,
      'totalCount': instance.totalCount,
    };

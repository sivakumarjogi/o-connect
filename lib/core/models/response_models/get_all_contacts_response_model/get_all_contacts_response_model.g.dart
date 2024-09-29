// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_contacts_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllContactsResponseModel _$GetAllContactsResponseModelFromJson(
        Map<String, dynamic> json) =>
    GetAllContactsResponseModel(
      statusCode: json['statusCode'] as int,
      status: json['status'] as String,
      message: json['message'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
      body: json['body'],
      totalCount: json['totalCount'],
    );

Map<String, dynamic> _$GetAllContactsResponseModelToJson(
        GetAllContactsResponseModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'body': instance.body,
      'totalCount': instance.totalCount,
    };

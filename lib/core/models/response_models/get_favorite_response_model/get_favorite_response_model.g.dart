// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_favorite_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetFavoriteContacts _$GetFavoriteContactsFromJson(Map<String, dynamic> json) =>
    GetFavoriteContacts(
      statusCode: json['statusCode'] as int,
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'],
      body: json['body'],
      totalCount: json['totalCount'],
    );

Map<String, dynamic> _$GetFavoriteContactsToJson(
        GetFavoriteContacts instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'body': instance.body,
      'totalCount': instance.totalCount,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_group_details_by_group_id_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetGroupsDetailsByGroupIdResponseModel
    _$GetGroupsDetailsByGroupIdResponseModelFromJson(
            Map<String, dynamic> json) =>
        GetGroupsDetailsByGroupIdResponseModel(
          statusCode: json['statusCode'] as int,
          status: json['status'] as String,
          message: json['message'] as String?,
          data: Data.fromJson(json['data'] as Map<String, dynamic>),
          body: json['body'],
          totalCount: json['totalCount'],
        );

Map<String, dynamic> _$GetGroupsDetailsByGroupIdResponseModelToJson(
        GetGroupsDetailsByGroupIdResponseModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'body': instance.body,
      'totalCount': instance.totalCount,
    };

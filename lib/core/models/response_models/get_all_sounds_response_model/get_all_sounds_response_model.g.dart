// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_sounds_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllSoundsResponseModel _$GetAllSoundsResponseModelFromJson(
        Map<String, dynamic> json) =>
    GetAllSoundsResponseModel(
      status: json['status'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => GetAllSoundsResponseModelDatum.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllSoundsResponseModelToJson(
        GetAllSoundsResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

GetAllSoundsResponseModelDatum _$GetAllSoundsResponseModelDatumFromJson(
        Map<String, dynamic> json) =>
    GetAllSoundsResponseModelDatum(
      category: json['category'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => DatumDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllSoundsResponseModelDatumToJson(
        GetAllSoundsResponseModelDatum instance) =>
    <String, dynamic>{
      'category': instance.category,
      'data': instance.data,
    };

DatumDatum _$DatumDatumFromJson(Map<String, dynamic> json) => DatumDatum(
      name: json['name'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$DatumDatumToJson(DatumDatum instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };

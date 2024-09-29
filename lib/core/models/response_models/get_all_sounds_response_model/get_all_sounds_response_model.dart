import 'package:json_annotation/json_annotation.dart';

part 'get_all_sounds_response_model.g.dart';

@JsonSerializable()
class GetAllSoundsResponseModel {
  bool status;
  List<GetAllSoundsResponseModelDatum> data;

  GetAllSoundsResponseModel({
    required this.status,
    required this.data,
  });

  factory GetAllSoundsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAllSoundsResponseModel(
        status: json["status"],
        data: List<GetAllSoundsResponseModelDatum>.from(json["data"]
            .map((x) => GetAllSoundsResponseModelDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

@JsonSerializable()
class GetAllSoundsResponseModelDatum {
  String category;
  List<DatumDatum> data;

  GetAllSoundsResponseModelDatum({
    required this.category,
    required this.data,
  });

  factory GetAllSoundsResponseModelDatum.fromJson(Map<String, dynamic> json) =>
      GetAllSoundsResponseModelDatum(
        category: json["category"],
        data: List<DatumDatum>.from(
            json["data"].map((x) => DatumDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

@JsonSerializable()
class DatumDatum {
  String name;
  String url;

  DatumDatum({
    required this.name,
    required this.url,
  });

  factory DatumDatum.fromJson(Map<String, dynamic> json) => DatumDatum(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}

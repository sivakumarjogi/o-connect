// To parse this JSON data, do
//
//     final generateTokenModel = generateTokenModelFromJson(jsonString);

import 'dart:convert';

GenerateTokenModel generateTokenModelFromJson(String str) => GenerateTokenModel.fromJson(json.decode(str));

String generateTokenModelToJson(GenerateTokenModel data) => json.encode(data.toJson());

class GenerateTokenModel {
  bool? status;
  Data? data;

  GenerateTokenModel({
    this.status,
    this.data,
  });

  GenerateTokenModel copyWith({
    bool? status,
    Data? data,
  }) =>
      GenerateTokenModel(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory GenerateTokenModel.fromJson(Map<String, dynamic> json) => GenerateTokenModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  String? tokenKey;

  Data({
    this.tokenKey,
  });

  Data copyWith({
    String? tokenKey,
  }) =>
      Data(
        tokenKey: tokenKey ?? this.tokenKey,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tokenKey: json["tokenKey"],
  );

  Map<String, dynamic> toJson() => {
    "tokenKey": tokenKey,
  };
}

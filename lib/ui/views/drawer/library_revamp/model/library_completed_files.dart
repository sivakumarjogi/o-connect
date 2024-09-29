// To parse this JSON data, do
//
//     final libraryCompletedFilesModel = libraryCompletedFilesModelFromJson(jsonString);

import 'dart:convert';

LibraryCompletedFilesModel libraryCompletedFilesModelFromJson(String str) => LibraryCompletedFilesModel.fromJson(json.decode(str));

String libraryCompletedFilesModelToJson(LibraryCompletedFilesModel data) => json.encode(data.toJson());

class LibraryCompletedFilesModel {
  bool? status;
  Map<String, int>? data;
  String? currentRegion;

  LibraryCompletedFilesModel({
    this.status,
    this.data,
    this.currentRegion,
  });

  LibraryCompletedFilesModel copyWith({
    bool? status,
    Map<String, int>? data,
    String? currentRegion,
  }) =>
      LibraryCompletedFilesModel(
        status: status ?? this.status,
        data: data ?? this.data,
        currentRegion: currentRegion ?? this.currentRegion,
      );

  factory LibraryCompletedFilesModel.fromJson(Map<String, dynamic> json) => LibraryCompletedFilesModel(
        status: json["status"],
        data: Map.from(json["data"]!).map((k, v) => MapEntry<String, int>(k, v)),
        currentRegion: json["currentRegion"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "currentRegion": currentRegion,
      };
}

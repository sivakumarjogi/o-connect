// To parse this JSON data, do
//
//     final speakerRequestModel = speakerRequestModelFromJson(jsonString);

import 'dart:convert';

SpeakerRequestModel speakerRequestModelFromJson(String str) => SpeakerRequestModel.fromJson(json.decode(str));

String speakerRequestModelToJson(SpeakerRequestModel data) => json.encode(data.toJson());

class SpeakerRequestModel {
  String? name;
  int? id;
  String? email;
  dynamic profilePic;

  SpeakerRequestModel({
    this.name,
    this.id,
    this.email,
    this.profilePic,
  });

  SpeakerRequestModel copyWith({
    String? name,
    int? id,
    String? email,
    dynamic profilePic,
  }) =>
      SpeakerRequestModel(
        name: name ?? this.name,
        id: id ?? this.id,
        email: email ?? this.email,
        profilePic: profilePic ?? this.profilePic,
      );

  factory SpeakerRequestModel.fromJson(Map<String, dynamic> json) => SpeakerRequestModel(
    name: json["name"],
    id: json["id"],
    email: json["email"],
    profilePic: json["profilePic"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "email": email,
    "profilePic": profilePic,
  };
}

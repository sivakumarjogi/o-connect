import 'dart:convert';

import 'package:equatable/equatable.dart';

class VideoShareModel extends Equatable {
  final String id;
  final String url;
  final String fileName;
  final String? thumbnail;
  final String? fileSize;
  final DateTime? createdDate;

  const VideoShareModel({
    required this.id,
    required this.url,
    required this.fileName,
    this.thumbnail,
    this.fileSize,
    this.createdDate,
  });

  @override
  List<Object> get props => [
        id,
        url,
        fileName,
      ];

  factory VideoShareModel.fromMap(Map<String, dynamic> map) {
    return VideoShareModel(
      id: map['_id'] ?? '',
      url: map['url'] ?? '',
      fileName: map['file_name'] ?? '',
      fileSize: map['file_size'] ?? '',
      createdDate: map['createOn'] ?? '',
    );
  }

  factory VideoShareModel.fromJson(String source) =>
      VideoShareModel.fromMap(json.decode(source));
}

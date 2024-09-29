import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:o_connect/ui/views/drawer/library_revamp/model/library_files_model.dart';

class InitialPresentationData extends Equatable {
  final int? ou;
  final String? presentationUrl;
  final String? fileName;
  final String? fileType;
  final double? width;
  final double? height;
  List<ConvertedImage>? convertedImages;

  InitialPresentationData({
    this.ou,
    this.presentationUrl,
    this.fileName,
    this.fileType,
    this.width,
    this.height,
    this.convertedImages = const [],
  });

  @override
  List<Object?> get props {
    return [
      ou,
      presentationUrl,
      fileName,
      fileType,
      width,
      height,
      convertedImages,
    ];
  }

  factory InitialPresentationData.fromMap(Map<String, dynamic> map) {
    return InitialPresentationData(
      ou: map['ou']?.toInt(),
      presentationUrl: map['presentationUrl'],
      fileName: map['file_name'],
      fileType: map['fileType'],
      width: double.tryParse((map['width'] ?? 0).toString()),
      height: double.tryParse((map['height'] ?? 0).toString()),
      convertedImages: map["data"] == null
          ? []
          : List<ConvertedImage>.from(
              map["data"]!.map((x) {
                return ConvertedImage.fromJson(x);
              }),
            ),
    );
  }

  factory InitialPresentationData.fromJson(String source) => InitialPresentationData.fromMap(json.decode(source));
}

import 'dart:convert';

import 'package:equatable/equatable.dart';

class InitialTheme extends Equatable {
  final String id;
  final String category;
  final String name;
  final String type;
  final String fileName;
  final String backgroundImageUrl;
  final String chatUrl;
  final String onScreenUrl;
  final bool? isNew;

  const InitialTheme({
    required this.id,
    required this.category,
    required this.name,
    required this.type,
    required this.fileName,
    required this.backgroundImageUrl,
    required this.chatUrl,
    required this.onScreenUrl,
    this.isNew,
  });

  @override
  List<Object?> get props {
    return [
      id,
      category,
      name,
      type,
      fileName,
      backgroundImageUrl,
      chatUrl,
      onScreenUrl,
      isNew,
    ];
  }

  factory InitialTheme.fromMap(Map<String, dynamic> map) {
    return InitialTheme(
      id: map['_id'] ?? '',
      category: map['category'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      fileName: map['fileName'] ?? '',
      backgroundImageUrl: map['backgroundImageUrl'] ?? '',
      chatUrl: map['chatUrl'] ?? '',
      onScreenUrl: map['onScreenUrl'] ?? '',
      isNew: map['isNew'],
    );
  }

  factory InitialTheme.fromJson(String source) => InitialTheme.fromMap(json.decode(source));
}

import 'dart:convert';

import 'package:equatable/equatable.dart';

class InitialPushLink extends Equatable {
  final PushLinkData data;
  const InitialPushLink({
    required this.data,
  });

  @override
  List<Object> get props => [data];

  factory InitialPushLink.fromMap(Map<String, dynamic> map) {
    return InitialPushLink(
      data: PushLinkData.fromMap(map['dataforSocket']),
    );
  }

  factory InitialPushLink.fromJson(String source) => InitialPushLink.fromMap(json.decode(source));
}

class PushLinkData extends Equatable {
  final String message;
  final String btnUrl;
  final String roleType;
  final int userId;
  const PushLinkData({
    required this.message,
    required this.btnUrl,
    required this.roleType,
    required this.userId,
  });

  factory PushLinkData.fromMap(Map<String, dynamic> map) {
    return PushLinkData(
      message: map['textMessage'] ?? '',
      btnUrl: map['buttonUrl'] ?? '',
      roleType: map['roleType'] ?? '',
      userId: map['userId']?.toInt() ?? 0,
    );
  }
  factory PushLinkData.fromJson(String source) => PushLinkData.fromMap(json.decode(source));

  @override
  List<Object> get props => [message, btnUrl, roleType, userId];
}
